import 'package:get/get.dart';
import 'package:todoapp/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final RxList <Task> taskList = <Task>[].obs;

 Future<int> addTask({Task? task}){
   return DBHelper.insert(task);
 }

 //this Function is used to get data From DataBase//
 Future<void> getTasks()async{
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  //this Function is used to delete data//
  void deleteTasks(Task task)async{
    await DBHelper.delete(task);
    getTasks();
  }

  void deleteAllTasks()async{
    await DBHelper.deleteAll();
    getTasks();
  }

  //this Function is used to update data /
  void markTaskCompleted(int id)async{
    await DBHelper.update(id);
    getTasks();
  }
}
