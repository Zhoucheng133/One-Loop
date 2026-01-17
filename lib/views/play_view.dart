import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';

class PlayView extends StatefulWidget {

  final AudioItem audioItem;

  const PlayView({super.key, required this.audioItem});

  @override
  State<PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {

  final Controller controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.playItem.value=widget.audioItem;
    });
  }

  @override
  void dispose() {
    controller.handler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
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
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('play'.tr),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.audioItem.name,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FButton.icon(
                  style: FButtonStyle.ghost(),
                  onPress: (){
                    if(controller.playing.value){
                      controller.handler.pause();
                    }
                    else{
                      controller.handler.play();
                    }
                  }, 
                  child: Icon(
                    controller.playing.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 50.0,
                  )
                ),
                const SizedBox(width: 15.0),
                FButton.icon(
                  style: FButtonStyle.ghost(),
                  onPress: (){
                    controller.handler.seek(Duration.zero);
                  }, 
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 40.0,
                  )
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() => 
              Material(
                child: SliderTheme(
                  data: SliderThemeData(
                    overlayColor: Colors.transparent,
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                    inactiveTrackColor: Colors.grey.withAlpha(50)
                  ),
                  child: Slider(
                    value: controller.percent.value, 
                    onChanged: (value){
                      controller.handler.pause();
                      controller.percent.value=value;
                    },
                    onChangeEnd: (value) {
                      controller.handler.seek(
                        Duration(
                          milliseconds: (controller.percent.value*controller.milliseconds.value).toInt()
                        )
                      );
                      controller.playing.value=true;
                    }
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}