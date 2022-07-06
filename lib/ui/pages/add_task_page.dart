// ignore_for_file: prefer_final_fields, non_constant_identifier_names, curly_braces_in_flow_control_structures, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controllers/task_controller.dart';
import 'package:todoapp/ui/widgets/button.dart';

import '../../models/task.dart';
import '../theme.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    //final MQ=MediaQuery.of(context);
    //final isLandScape = MQ.orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _AppBar(),
      body: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: Headingstyle,
              ),
              InputField(
                controller: _titleController,
                title: "Title",
                hint: "Enter title here",
              ),
              InputField(
                controller: _noteController,
                title: "Note",
                hint: "Enter note here",
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => getDateFromUser(),
                  icon: const Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: true),
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: false),
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                  title: "Remind",
                  hint: "$_selectedRemind minutes early",
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Colors.blueGrey,
                        items: remindList.map((value) {
                          return DropdownMenuItem(
                              value: value,
                              child: Text(
                                "$value",
                                style: const TextStyle(color: Colors.white),
                              ));
                        }).toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 32,
                        ),
                        elevation: 4,
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedRemind = newValue!;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  )),
              InputField(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Colors.blueGrey,
                        items: _repeatList.map((value) {
                          return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ));
                        }).toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 32,
                        ),
                        elevation: 4,
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue2) {
                          setState(() {
                            _selectedRepeat = newValue2!;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  )),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ColorPaletee(),
                  MyButton(
                      label: "Create Task",
                      onTap: () {
                        _validateDate();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _AppBar() => AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("images/person.jpeg"),
            radius: 18,
          ),
          SizedBox(
            width: 20,
          )
        ],
      );

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        duration: const Duration(seconds: 5),
      );
    } else {
      print("Some Thing Unusual Happened");
    }
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 1 ,
        // 0 means that it's not completed
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print(value);
  }

  Column _ColorPaletee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: Titlestyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
                radius: 14,
              ),
            ),
          ),
        ))
      ],
    );
  }

  getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      //initialEntryMode:DatePickerEntryMode.calendar,
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    // this Logic is made to set the new value that the user will put it//
    if (_pickedDate != null) {
      setState(() => _selectedDate = _pickedDate);
    } else {
      print("It's null or something is wrong");
    }
  }

  getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      //initialEntryMode:TimePickerEntryMode.dial ,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    // this Logic is made to set the new value that the user will put it//
    String _formattedTime = _pickedTime!.format(context);
    if(isStartTime)
      setState(() => _startTime = _formattedTime);
     else if(!isStartTime)
      setState(() => _endTime = _formattedTime);
     else {
      print("Time Cancelled or something is wrong");
    }
  }
}
