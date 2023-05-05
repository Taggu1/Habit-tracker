import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:habbit_tracker/providers/providers.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:habbit_tracker/utils.dart';
import '../constants.dart';
import '../widgets/add_habit_screen_widgets/habit_name_text_field.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/custom_message_dialog.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  static const routeName = "/add-habit-screen";
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  @override
  final TextEditingController _habitNameControoler = TextEditingController();
  var _habitTimeInTheDay = DateTime.now();
  final _time = Time(hour: DateTime.now().hour, minute: DateTime.now().minute);
  var _validate = false;
  Color _color = availableColors[0];

  Future<void> showDatePicker() async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        onChange: (time) {},
        onChangeDateTime: (time) {
          _habitTimeInTheDay = time;
          print(_habitTimeInTheDay);
        },
        accentColor: Colors.black,
        okStyle: const TextStyle(color: Colors.black),
        cancelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget buildButton(Function onPressedFunc, String title) {
    return ElevatedButton(
      onPressed: () => onPressedFunc(),
      style: ElevatedButton.styleFrom(
        primary: kBlackColor,
        onPrimary: kWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefultBorderRadius),
        ),
      ),
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _color,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HabitNameTextField(
                  validate: _validate,
                  onChangedFunc: (value) {
                    _habitNameControoler.text = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlockPicker(
                  pickerColor: _color,
                  availableColors: availableColors,
                  onColorChanged: (color) {
                    setState(() {
                      _color = color;
                    });
                  },
                ),
                const SizedBox(height: 30),
                buildButton(showDatePicker, "Pick Habit Time"),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: buildButton(() {
                    final habitIndex = ref.read(habitsProvider).indexWhere(
                          (element) =>
                              element.habitName ==
                              _habitNameControoler.text.trim(),
                        );
                    setState(() {
                      _habitNameControoler.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });
                    if (_habitNameControoler.text.isNotEmpty &&
                        _habitNameControoler.text.length < 150 &&
                        habitIndex == -1) {
                      ref
                          .read(habitsProvider.notifier)
                          .addHabit(_habitNameControoler.text,
                              _habitTimeInTheDay, _color)
                          .then((value) {
                        Navigator.of(context).pop();
                        showAppDefultSnackbar(context,
                            "Habit got added, We will notify you ${Emojis.emotion_red_heart}");
                      });
                    } else if (habitIndex != -1) {
                      showDialog(
                        context: context,
                        builder: (ctx) => const CustomMessageDialog(
                          title: "Invaild name",
                          message: "This habit already exists",
                        ),
                      );
                    }
                  }, "Add habit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
