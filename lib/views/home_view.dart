import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final controller = Get.find<Controller>();
  
  @override
  Widget build(BuildContext context) {
    return controller.audioList.isEmpty ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.close_rounded,
            size: 30,
          ),
          const SizedBox(height: 5),
          Text(
            'listNone'.tr,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ) : Container();
  }
}