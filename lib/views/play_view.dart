import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('play'.tr),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.audioItem.name,
              style: GoogleFonts.notoSansSc(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            IconButton(
              onPressed: (){
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
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 50.0,
              )
            )
          ],
        ),
      ),
    );
  }
}