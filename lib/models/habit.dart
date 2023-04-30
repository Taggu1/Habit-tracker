import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habbit_tracker/main.dart';
import 'package:habbit_tracker/notifications.dart';
import 'package:habbit_tracker/utils.dart';

enum HabitStatues {
  notDoneAndBefore,
  notDoneAndAfter,
  notDoneAndSameDay,
  doneAndBefore,
  doneAndAfter,
  doneAndCurrent,
}

class Habit {
  final String habitName;
  final DateTime habitTime;
  final int doneCount;
  final DateTime lastDoneDate;
  final Color habitColor;
  String? previousLastDoneDate;

  Habit({
    required this.doneCount,
    required this.habitName,
    required this.habitTime,
    required this.lastDoneDate,
    required this.habitColor,
    this.previousLastDoneDate,
  });

  factory Habit.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Habit(
      doneCount: data?['doneCount'],
      habitName: data?['habitName'],
      habitColor: stringToColor(data?['habitColor']),
      habitTime: DateTime.parse(data?['habitTime']),
      lastDoneDate: DateTime.parse(data?["lastDoneDate"]),
      previousLastDoneDate: data?["previousLastDoneDate"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "habitName": habitName,
      "doneCount": doneCount,
      "habitTime": habitTime.toIso8601String(),
      "lastDoneDate": lastDoneDate.toIso8601String(),
      "previousLastDoneDate": previousLastDoneDate ?? "",
      "habitColor": habitColor.toString()
    };
  }
}

class HabitsProvider extends StateNotifier<List<Habit>> {
  final String userId;
  final AsyncValue<QuerySnapshot<Map<String, dynamic>>> habitStreamProvider;
  final AsyncValue<QuerySnapshot<Map<String, dynamic>>> daysDataStream;
  final _database = FirebaseFirestore.instance;

  HabitsProvider(
      {required this.userId,
      required this.habitStreamProvider,
      required this.daysDataStream})
      : super([]) {
    habitStreamProvider.when(
      data: (item) {
        state = item.docs.map((e) => Habit.fromFirestore(e)).toList();
      },
      error: (e, st) {},
      loading: () {},
    );
  }

  Future<void> addHabit(
      String habitName, DateTime habitTime, Color habitColor) async {
    final habitsRef =
        _database.collection("users").doc(userId).collection("habits");
    final daysRef =
        _database.collection("users").doc(userId).collection("days");

    final habit = Habit(
      doneCount: 0,
      habitName: habitName,
      habitTime: habitTime,
      habitColor: habitColor,
      lastDoneDate: DateTime.now().subtract(
        const Duration(days: 1),
      ),
    );

    try {
      await habitsRef.doc(habit.habitName).set(
            habit.toFirestore(),
          );
      await daysRef.doc(dayFormatedToAString(DateTime.now())).set(
        {habit.habitName: false},
        SetOptions(merge: true),
      );
      await createHabitReminderNotification(
        habit,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> archiveHabit(int index) async {
    final habit = state[index];
    final userRef = _database.collection("users").doc(userId);
    final habitRef = userRef.collection("habits").doc(habit.habitName);
    final daysRef =
        _database.collection("users").doc(userId).collection("days");

    try {
      habitRef.delete();
      final daysRefrences =
          await daysRef.where(habit.habitName, isEqualTo: true).get();
      for (var day in daysRefrences.docs) {
        day.reference.update(
          {habit.habitName: false},
        );
      }
      AwesomeNotifications().cancelSchedule(uniqueIdFromDate(habit.habitTime));
    } catch (e) {
      rethrow;
    }
  }

  void updateHabit(int index, DateTime date) {
    final habit = state[index];
    final habitRef = _database
        .collection("users")
        .doc(userId)
        .collection("habits")
        .doc(habit.habitName);
    final daysRef =
        _database.collection("users").doc(userId).collection("days");

    final day = dayFormatedToAString(date);
    try {
      habitRef.update(
        {
          "lastDoneDate": date.isAfter(habit.lastDoneDate)
              ? date.toIso8601String()
              : DateTime.now().toIso8601String(),
          "doneCount": FieldValue.increment(1),
          "previousLastDoneDate": habit.lastDoneDate.toIso8601String(),
        },
      );

      daysRef.doc(day).set(
        {
          habit.habitName: true,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      rethrow;
    }
  }

  String dayFormatedToAString(DateTime date) {
    return "${date.day}-${date.month}";
  }

  Future<dynamic> checkIfHabitIsDone(
      int index, DateTime date, String habitName) async {
    final day = dayFormatedToAString(date);
    final dayRef =
        _database.collection("users").doc(userId).collection("days").doc(day);

    final dayData = await dayRef.get();
    return dayData.data()?[habitName];
  }

  void cancelUpdate(int index, DateTime date) {
    final daysRef =
        _database.collection("users").doc(userId).collection("days");
    final habitsRef =
        _database.collection("users").doc(userId).collection("habits");
    final habit = state[index];
    if (habit.doneCount == 0) {
      return;
    }

    final habitRef = habitsRef.doc(habit.habitName);

    try {
      habitRef.update(
        {
          "lastDoneDate": habit.previousLastDoneDate!.isEmpty
              ? habit.lastDoneDate.toIso8601String()
              : habit.previousLastDoneDate,
          "doneCount": FieldValue.increment(-1),
          "previousLastDoneDate": "",
        },
      );
      final day = dayFormatedToAString(date);
      daysRef.doc(day).set({
        habit.habitName: false,
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeHabit(String userId, Habit habit) async {
    final habitsRef =
        _database.collection("users").doc(userId).collection("habits");
    await habitsRef.doc(habit.habitName).delete();
  }

  HabitStatues boolToHabitStates(
      bool? statues, DateTime dayDate, DateTime currentDay) {
    if (statues == null || statues == false) {
      if (currentDay == dayDate) {
        return HabitStatues.notDoneAndSameDay;
      } else if (dayDate.isBefore(currentDay)) {
        return HabitStatues.notDoneAndBefore;
      } else {
        return HabitStatues.notDoneAndAfter;
      }
    } else {
      if (currentDay == dayDate) {
        return HabitStatues.doneAndCurrent;
      } else if (dayDate.isBefore(currentDay)) {
        return HabitStatues.doneAndBefore;
      } else {
        return HabitStatues.doneAndAfter;
      }
    }
  }

  Stream<List<List<dynamic>>> checkIfHabitsAreDone(int index) async* {
    final currentDay = DateTime.now();
    var weekDay = mostRecentSunday(currentDay);

    final habitName = state[index].habitName;
    final daysList = List.generate(
      7,
      (index) {
        return weekDay.add(
          Duration(days: index),
        );
      },
    );
    final tempList = [];

    daysDataStream.whenData((value) {
      for (var dayDate in daysList) {
        final day = dayFormatedToAString(dayDate);
        bool? statues;
        List<QueryDocumentSnapshot<Map>>? dayData =
            value.docs.where((element) => element.id == day).toList();
        if (dayData.isEmpty) {
          statues = null;
        } else {
          statues = dayData.first.data()[habitName];
        }
        tempList.add(boolToHabitStates(statues, dayDate, currentDay));
      }
    });

    yield [tempList, daysList];
  }
}
