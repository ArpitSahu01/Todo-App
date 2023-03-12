
import 'package:get/get.dart';
import 'package:to_do_list/app/data/services/storage/repository.dart';

class HomeController extends GetxController{
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});


}