
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:to_do_list/app/data/services/storage/repository.dart';

import '../../data/models/task.dart';

class HomeController extends GetxController{
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});
  final formKey = GlobalKey<FormState>();
  final editCtrl = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editCtrl.dispose();
    super.onClose();

  }

  void changeChipIndex(int value){
    chipIndex.value = value;
  }

  bool addTask(Task task){
    if(tasks.contains(task)){
      return false;
    }
    tasks.add(task);
    return true;
  }

  void changeDeleting(bool value){
    deleting.value = value;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  void changeTask(Task? select) {
    task.value = select;
  }

   updateTask(Task task,String title){
    var todos = task.todos ?? [];
    if(containTodo(todos,title)){
      return false;
    }
    var todo = {"title":title, 'done':false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }
  bool containTodo(List todos,String title){
return todos.any((element)=>element['title'] == title);
  }
}