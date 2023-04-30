import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:habbit_tracker/constants.dart';
import 'package:intl/intl.dart';

import '../../models/habit.dart';

class HabitDaysRow extends StatelessWidget {
  final List<List<dynamic>> data;
  final bool whileLoading;
  final Function updateHabitWhileDone;
  final Function updateHabitWhileUndone;
  final Color habitColor;
  const HabitDaysRow({
    Key? key,
    required this.data,
    required this.habitColor,
    required this.updateHabitWhileDone,
    required this.updateHabitWhileUndone,
    required this.whileLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Cool");
    print("-");
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, index) {
          switch (data[0][index]) {
            case HabitStatues.notDoneAndBefore:
              return DayIconButtonOfRow(
                whileLoading: whileLoading,
                buttonfunc: updateHabitWhileUndone,
                date: data[1][index],
                backgroundColor: habitColor.withOpacity(0.2),
                textColor: habitColor,
                icon: Entypo.cancel,
              );

            case HabitStatues.notDoneAndSameDay:
              return DayIconButtonOfRow(
                whileLoading: whileLoading,
                buttonfunc: updateHabitWhileUndone,
                date: data[1][index],
                backgroundColor: habitColor.withOpacity(0.2),
                textColor: habitColor,
                icon: Entypo.cancel_circled,
              );

            case HabitStatues.notDoneAndAfter:
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                child: CircleAvatar(
                  backgroundColor: kSecondaryColor,
                  radius: 20,
                  child: Text(
                    DateFormat.E().format(data[1][index]),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              );
            case HabitStatues.doneAndBefore:
              return DayIconButtonOfRow(
                whileLoading: whileLoading,
                buttonfunc: updateHabitWhileDone,
                date: data[1][index],
                backgroundColor: habitColor,
                textColor: Colors.white,
                icon: Entypo.check,
              );

            case HabitStatues.doneAndCurrent:
              return DayIconButtonOfRow(
                whileLoading: whileLoading,
                buttonfunc: updateHabitWhileDone,
                date: data[1][index],
                backgroundColor: habitColor,
                textColor: Colors.white,
                icon: Entypo.check,
              );

            case HabitStatues.doneAndAfter:
              return const IconButton(
                onPressed: null,
                icon: Icon(Entypo.minus_circled),
              );
          }
          return const Text("s");
        },
      ),
    );
  }
}

class DayIconButtonOfRow extends StatelessWidget {
  const DayIconButtonOfRow({
    Key? key,
    required this.whileLoading,
    required this.buttonfunc,
    required this.date,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  final bool whileLoading;
  final Function buttonfunc;
  final DateTime date;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        radius: 20,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: whileLoading ? () {} : () => buttonfunc(date),
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
