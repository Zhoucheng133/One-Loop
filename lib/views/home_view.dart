import 'package:flutter/material.dart';
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
              style: TextStyle(
                color: Colors.grey
              ),
            ),
            trailing: IconButton(
              onPressed: ()=>showSheet(context, index), 
              icon: Icon(Icons.more_vert_rounded)
            ),
            onLongPress: () => showSheet(context, index),
            onTap: (){
              Get.to(()=>PlayView(audioItem: controller.audioList[index],));
            },
          );
        },
      )
    );
  }
}