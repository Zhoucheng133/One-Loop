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

  final audio=Audio();
  bool playing=false;

  @override
  void initState() {
    super.initState();
    audio.init(widget.audioItem);
  }

  @override
  void dispose() {
    super.dispose();
    audio.player.dispose();
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
          )
        ],
      ),
    );
  }
}