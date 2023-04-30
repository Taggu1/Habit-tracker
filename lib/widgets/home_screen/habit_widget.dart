import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habbit_tracker/providers/providers.dart';
import 'package:habbit_tracker/widgets/home_screen/habit_days_row.dart';

import '../../constants.dart';
import '../../models/habit.dart';
import '../custom_alirt_dialog.dart';

class HabitWidget extends ConsumerStatefulWidget {
  const HabitWidget({
    Key? key,
    required this.index,
    required this.habit,
  }) : super(key: key);

  final int index;
  final Habit habit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HabitWidgetState();
}

class _HabitWidgetState extends ConsumerState<HabitWidget> {
  Widget? rowWidget;
  void updateHabitWhileDone(DateTime date) {
    ref.read(habitsProvider.notifier).cancelUpdate(widget.index, date);
  }

  void updateHabitWhileUndone(DateTime date) {
    ref.read(habitsProvider.notifier).updateHabit(widget.index, date);
  }

  void archiveHabit() {
    showDialog(
      context: context,
      builder: (ctx) => CustomAlertDialog(
          message: "",
          title: "Do you want to delete this habit?",
          onPressedFunc: () {
            ref.read(habitsProvider.notifier).archiveHabit(widget.index);
            Navigator.of(context).pop();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onLongPress: archiveHabit,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.habit.habitName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "${widget.habit.doneCount}x",
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final data = snapshot.data as List<List<dynamic>>;
                    rowWidget = HabitDaysRow(
                      habitColor: widget.habit.habitColor,
                      data: data,
                      updateHabitWhileDone: updateHabitWhileDone,
                      updateHabitWhileUndone: updateHabitWhileUndone,
                      whileLoading: false,
                    );
                    return rowWidget ?? Container();
                  default:
                    return rowWidget ?? Container();
                }
              }),
              stream: ref
                  .watch(habitsProvider.notifier)
                  .checkIfHabitsAreDone(widget.index),
            ),
          ],
        ),
      ),
    );
  }
}
