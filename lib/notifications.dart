import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habbit_tracker/models/habit.dart';
import 'package:habbit_tracker/utils.dart';

Future<void> createHabitReminderNotification(Habit habit) async {
  final r = await AwesomeNotifications().createNotification(
    content: NotificationContent(
        category: NotificationCategory.Reminder,
        id: uniqueIdFromDate(habit.habitTime),
        channelKey: "scheduled_channel",
        title: habit.habitName,
        body: "Don't forget to do your habit",
        notificationLayout: NotificationLayout.Default),
    actionButtons: [],
    schedule: NotificationCalendar(
      preciseAlarm: true,
      hour: habit.habitTime.hour,
      minute: habit.habitTime.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
  print(r);
}

Future<void> cancleNotification() async {
  print("Canceled all notifications Lol");
  await AwesomeNotifications().cancelAllSchedules();
}
