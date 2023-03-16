import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/app/core/utils/extensions.dart';
import 'package:to_do_list/app/modules/home/controller.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
   ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
            (){
              var createdTask = homeCtrl.getTotalTask();
              var completedTasks = homeCtrl.getTotalDoneTask();
              var liveTasks = createdTask - completedTasks;
              var percent = (completedTasks/completedTasks * 100).toStringAsFixed(0);
              return ListView(
                children: [
                   Padding(
                     padding:  EdgeInsets.all(4.0.wp),
                     child: Text(
                       'My Report',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 24.0.sp,
                       ),
                     ),
                   ),


                ],
              );
            }
        ),
      ),
    );
  }
}
