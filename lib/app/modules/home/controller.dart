
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_list/app/data/services/storage/repository.dart';

import '../../data/models/task.dart';

class HomeController extends GetxController{
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});
  final formKey = GlobalKey<FormState>();
  final editCtrl = TextEditingController();
  final tabIndex = 0.obs;
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

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

  void changeTodos(List<dynamic> select){
    doingTodos.clear();
    doneTodos.clear();
     for(int i = 0; i<select.length; i++){
       var todo = select[i];
       var status = todo['done'];
       if(status == true){
         doneTodos.add(todo);
       }else{
         doingTodos.add(todo);
       }
     }
  }

  bool addTodo(String title) {
    var todo = {"title":title, 'done' : false};
    if(doingTodos.any((element) => mapEquals<String,dynamic>(todo, element))){
      return false;
    }
    var doneTodo = {"title":title, 'done' : true};
    if(doneTodos.any((element) => mapEquals(doneTodo, element))){
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos(){
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll(
      [
        ...doingTodos,
        ...doneTodos,
      ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title){
    var doingTodo = {'title': title,'done': false};
    int index = doingTodos.indexWhere((element) => mapEquals<String,dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {'title': title,'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos.indexWhere((element) => mapEquals(doneTodo, element));
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task){
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task){
    var res = 0;
    for(int i = 0; i< task.todos!.length;i++){
      if(task.todos![i]['done'] == true){
        res += 1;
      }
    }
    return res;
  }

  void changeTabIndex(int index){
    tabIndex.value  = index;
  }

}