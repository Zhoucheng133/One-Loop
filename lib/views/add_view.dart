import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
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
      }else if(!linkController.text.startsWith('http') && !linkController.text.startsWith('https')){
        showErrOkDialog(context, "addFailed".tr, 'invalidLink'.tr);
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
    }else{
      controller.addAudio(
        AudioItem(name: nameController.text, path: linkController.text, type: type)
      );
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      resizeToAvoidBottomInset: false,
      header: FHeader.nested(
        title: Text('add'.tr),
        prefixes: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () => Get.back(),
            child: Icon(
              FIcons.arrowLeft,
              size: 25,
            )
          )
        ],
        suffixes: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () => add(context),
            child: Icon(
              FIcons.plus,
              size: 25,
            )
          ),
        ],
      ),
      child: FTabs(
        control: FTabControl.lifted(
          index: type == AudioType.file ? 0 : 1, 
          onChange: (int index){
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {
              type = index == 0 ? AudioType.file : AudioType.network;
            });
          }
        ),
        children: [
          FTabEntry(
            label: Text('file'.tr), 
            child: FCard(
              title: Text("addFromFile".tr),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  FTextField(
                    label: Text('name'.tr),
                    control: FTextFieldControl.managed(
                      controller: nameController,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      FButton.raw(
                        onPress: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                          child: Text(
                            "select".tr,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        )
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
                ],
              ),
            )
          ),
          FTabEntry(
            label: Text('network'.tr), 
            child: FCard(
              title: Text("addFromNetwork".tr),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  FTextField(
                    label: Text('name'.tr),
                    control: FTextFieldControl.managed(
                      controller: nameController,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FTextField(
                    label: Text('link'.tr),
                    hint: "http(s)://",
                    control: FTextFieldControl.managed(
                      controller: linkController,
                    ),
                  ),
                ],
              ),
            )
          ),
        ]
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