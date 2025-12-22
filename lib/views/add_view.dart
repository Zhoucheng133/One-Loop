import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_loop/components/add_item.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/dialogs/dialogs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  String filePath="";

  void add(BuildContext context) async {

    final index=controller.audioList.indexWhere((element) => element.name == nameController.text);

    if (nameController.text.isEmpty) {
      showErrOkDialog(context, "addFailed".tr, 'emptyName'.tr);
      return;
    }else if(index!=-1){
      showErrOkDialog(context, "addFailed".tr, 'duplicateName'.tr);
      return;
    }else if (type == AudioType.file) {
      if (filePath.isEmpty) {
        showErrOkDialog(context, "addFailed".tr, 'emptyFile'.tr);
        return;
      }
    }else if (type == AudioType.network) {
      if (linkController.text.isEmpty) {
        showErrOkDialog(context, "addFailed".tr, 'emptyLink'.tr);
        return;
      }
    }

    if (type == AudioType.file && filePath.isNotEmpty) {
      final pickedFile = File(filePath);
      final appDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory(p.join(appDir.path, 'audioFiles'));

      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_${p.basename(pickedFile.path)}';
      final savedFile = File(p.join(audioDir.path, fileName));
      try {
        await pickedFile.copy(savedFile.path);
      } catch (e) {
        if(context.mounted) showErrOkDialog(context, "addFailed".tr, 'fileCopyFailed'.tr);
        return;
      }
      controller.addAudio(
        AudioItem(name: nameController.text, path: fileName, type: type)
      );
    }
    else{
      controller.addAudio(
        AudioItem(name: nameController.text, path: linkController.text, type: type)
      );
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('add'.tr),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                add(context);
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
              child: Row(
                children: [
                  FilledButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'],
                      );
                      if (result != null) {
                        setState(() {
                          filePath = result.files.single.path!;
                        });
                      }
                    }, 
                    child: Text('select'.tr)
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: filePath.isEmpty ?
                    Container() :
                    Text(
                      p.basename(filePath),
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
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

  @override
  void dispose() {
    linkController.dispose();
    nameController.dispose();
    super.dispose();
  }
}