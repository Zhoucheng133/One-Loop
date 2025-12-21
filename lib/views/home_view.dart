import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/dialogs/dialogs.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final controller = Get.find<Controller>();

  Future<void> listFiles() async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory(p.join(appDir.path, 'audioFiles'));
    if (audioDir.existsSync()) {
      print(audioDir.listSync().length);
    }
  }

  @override
  void initState() {
    super.initState();
    listFiles();
  }
  
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      controller.audioList.isEmpty ? Center(
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
      ) : ListView.builder(
        itemCount: controller.audioList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              controller.audioList[index].name,
            ),
            // subtitle: Text(p.basename(controller.audioList[index].path)),
            subtitle: Text(
              controller.audioList[index].type==AudioType.file ? 'file'.tr : 'network'.tr,
              style: GoogleFonts.notoSansSc(
                color: Colors.grey
              ),
            ),
            trailing: IconButton(
              onPressed: (){
                showModalBottomSheet(
                  context: context, 
                  clipBehavior: Clip.antiAlias,
                  builder: (context)=>Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit_rounded),
                        title: Text('rename'.tr),
                        onTap: () async {
                          Navigator.pop(context);
                          await showRenameDialog(context, controller.audioList[index].name);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete_rounded),
                        title: Text('delete'.tr),
                        onTap: () async {
                          Navigator.pop(context);
                          if(await showConfirmDialog(context, "deleteAudio".tr, "deleteAudioContent".tr, okText: 'delete') ?? false){
                            controller.removeAudio(controller.audioList[index]);
                          }
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom,),
                    ],
                  )
                );
              }, 
              icon: Icon(Icons.more_vert_rounded)
            ),
            onTap: (){

            },
          );
        },
      )
    );
  }
}