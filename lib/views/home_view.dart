import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/dialogs/dialogs.dart';
import 'package:one_loop/views/play_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final controller = Get.find<Controller>();

  void showSheet(BuildContext context, int index){
    showModalBottomSheet(
      context: context, 
      clipBehavior: Clip.antiAlias,
      builder: (context)=>Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FTileGroup(
            children: [
              FTile(
                prefix: Icon(Icons.edit_rounded),
                title: Text('rename'.tr),
                onPress: () async {
                  Navigator.pop(context);
                  await showRenameDialog(context, controller.audioList[index].name);
                },
              ),
              FTile(
                prefix: Icon(Icons.delete_rounded),
                title: Text('delete'.tr),
                onPress: () async {
                  Navigator.pop(context);
                  if(await showConfirmDialog(context, "deleteAudio".tr, "deleteAudioContent".tr, okText: 'delete') ?? false){
                    controller.removeAudio(controller.audioList[index]);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom,),
        ],
      )
    );
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
        padding: EdgeInsetsGeometry.zero,
        itemCount: controller.audioList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: FTile(
              title: Text(
                controller.audioList[index].name,
              ),
              subtitle: Text(
                controller.audioList[index].type==AudioType.file ? 'file'.tr : 'network'.tr,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              suffix: IconButton(
                onPressed: ()=>showSheet(context, index), 
                icon: Icon(Icons.more_vert_rounded)
              ),
              onPress: (){
                Get.to(()=>PlayView(audioItem: controller.audioList[index],));
              },
            ),
          );
        },
      )
    );
  }
}