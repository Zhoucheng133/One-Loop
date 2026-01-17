import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/audio.dart';
import 'package:one_loop/controllers/controller.dart';

class PlayView extends StatefulWidget {

  final AudioItem audioItem;

  const PlayView({super.key, required this.audioItem});

  @override
  State<PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {

  final Audio audio=Get.find();
  bool playing=false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audio.setItem(widget.audioItem);
    });
  }

  @override
  void dispose() {
    audio.player.stop();
    audio.player.seek(Duration.zero);
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
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FButton.icon(
                style: FButtonStyle.ghost(),
                onPress: (){
                  if(playing){
                    audio.pause();
                    setState(() {
                      playing=false;
                    });
                  }
                  else{
                    audio.play();
                    setState(() {
                      playing=true;
                    });
                  }
                }, 
                child: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 50.0,
                )
              ),
              const SizedBox(width: 15.0),
              FButton.icon(
                style: FButtonStyle.ghost(),
                onPress: (){
                  audio.player.seek(Duration.zero);
                }, 
                child: Icon(
                  Icons.refresh_rounded,
                  size: 40.0,
                )
              ),
            ],
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
                    value: audio.percent.value, 
                    onChanged: (value){
                      setState(() {
                        playing=false;
                      });
                      audio.player.pause();
                      audio.percent.value=value;
                    },
                    onChangeEnd: (value) async {
                      setState(() {
                        playing=true;
                      });
                      await audio.player.seek(
                        Duration(
                          milliseconds: (audio.percent.value*audio.milliseconds.value).toInt()
                        )
                      );
                      audio.player.play();
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