import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habbit_tracker/main.dart';

import '../app_snackbar.dart';
import 'habit_widget.dart';
import '../../providers/providers.dart';

class HabitsList extends ConsumerStatefulWidget {
  const HabitsList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HabitsListState();
}

class _HabitsListState extends ConsumerState<HabitsList> {
  /* @override
  void initState() {
    AwesomeNotifications().actionStream.listen(
      (notification) {
        if (notification.channelKey == 'scheduled_channel' && Platform.isIOS) {
          AwesomeNotifications().getGlobalBadgeCounter().then(
                (value) =>
                    AwesomeNotifications().setGlobalBadgeCounter(value - 1),
              );
        }
        if (notification.payload != null) {
          ref.read(habitsProvider.notifier).updateHabit(
                notification.payload!["index"] as int,
                DateTime.parse(
                  notification.payload!["date"] as String,
                ),
              );
        }
      },
    );

    AwesomeNotifications().createdStream.listen(
      (notification) {
        showAppDefultSnackbar(context,
            "Habit got added we will notify you ${Emojis.emotion_red_heart}");
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitsProvider);

    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: HabitWidget(
            index: index,
            habit: habits[index],
          ),
        );
      },
      itemCount: habits.length,
    );
  }
}
