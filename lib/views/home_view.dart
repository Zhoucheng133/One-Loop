import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_loop/components/audio_list.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('OneLoop'),
      ),
      body: controller.audioList.isEmpty ? Center(
        child: Column(
          children: [
            
          ],
        ),
      ) : AudioList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.add_rounded),
      ),
    );
  }
}