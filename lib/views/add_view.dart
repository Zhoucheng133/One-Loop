import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_loop/components/add_item.dart';
import 'package:one_loop/controllers/controller.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  final controller = Get.find<Controller>();
  AudioType type = AudioType.file;
  final linkController=TextEditingController();
  final nameController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('add'.tr),
        scrolledUnderElevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.add_rounded,
                size: 30,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AddItem(
              label: 'type'.tr, 
              child: SegmentedButton(
                segments:[
                  ButtonSegment(
                    value: AudioType.file,
                    icon: Icon(Icons.file_copy_rounded),
                    label: Text('file'.tr),
                  ),
                  ButtonSegment(
                    value: AudioType.network,
                    icon: Icon(Icons.link_rounded),
                    label: Text('network'.tr),
                  ),
                ],
                selected: {type},
                onSelectionChanged: (value) {
                  setState(() {
                    type = value.first;
                  });
                },
              )
            ),
            AddItem(
              label: 'name'.tr,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'name'.tr,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(10)
                )
              )
            ),
            type == AudioType.file ?
            AddItem(
              label: 'file'.tr,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: (){
                    // TODO 选择文件
                  }, 
                  child: Text('select'.tr)
                ),
              )
            ) :
            AddItem(
              label: 'link'.tr,
              child: TextField(
                controller: linkController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'http(s)://',
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(10)
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}