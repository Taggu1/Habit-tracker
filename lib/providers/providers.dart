import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habbit_tracker/models/habit.dart';

import '../models/user.dart';

final userProvider = StateNotifierProvider<UserProvider, AppUser>((ref) {
  return UserProvider();
});

final habitsDataProvider = StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
  (ref) {
    final uid = ref.watch(userProvider).uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("habits")
        .snapshots();
  },
);

final daysDataProvider = StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
  (ref) {
    final uid = ref.watch(userProvider).uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("days")
        .snapshots();
  },
);

final habitsProvider =
    StateNotifierProvider<HabitsProvider, List<Habit>>((ref) {
  final userId = ref.watch(userProvider).uid;
  final stream = ref.watch(habitsDataProvider);
  final daysDataStream = ref.watch(daysDataProvider);

  return HabitsProvider(
      userId: userId,
      habitStreamProvider: stream,
      daysDataStream: daysDataStream);
});
