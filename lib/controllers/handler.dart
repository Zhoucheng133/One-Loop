import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Handler extends BaseAudioHandler with QueueHandler, SeekHandler{

  final controller = Get.find<Controller>();
  late MediaItem item;

  Future<void> initPlayer() async {
    await player.setLoopMode(LoopMode.one);
    player.positionStream.listen((position) {
      if(controller.playItem.value!=null){
        controller.percent.value=position.inMilliseconds/controller.milliseconds.value;
      }
    });
    player.playbackEventStream.listen((_) => setMedia());
  }

  Handler(){
    initPlayer();
  }

  AudioPlayer player = AudioPlayer();

  AudioItem? playItem;

  void setMedia(){
    if(controller.playItem.value==null){
      return;
    }
    playbackState.add(
      PlaybackState(
        playing: player.playing,
        controls: [
          player.playing ? MediaControl.pause : MediaControl.play,
        ],
        updatePosition: player.position,
        processingState: AudioProcessingState.ready,
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
      )
    );
    item=MediaItem(
      id: controller.playItem.value!.path,
      title: controller.playItem.value!.name,
      artist: "One Loop",
      artUri: null,
      duration: Duration(milliseconds: controller.milliseconds.value),
    );
    mediaItem.add(item);
  }

  @override
  Future<void> play() async {
    controller.playing.value=true;
    if(controller.playItem.value==null){
      return;
    }
    if(controller.playItem.value!=playItem){
      if(controller.playItem.value!.type==AudioType.file){
        final appDir = await getApplicationDocumentsDirectory();
        final audioPath = p.join(appDir.path, 'audioFiles', controller.playItem.value!.path);
        await player.setFilePath(audioPath);
      }else{
        await player.setUrl(controller.playItem.value!.path);
      }
    }
    controller.milliseconds.value=player.duration!.inMilliseconds;
    player.play();
    playItem=controller.playItem.value;
  }

  @override
  Future<void> pause() async {
    player.pause();
    controller.playing.value=false;
  }

  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
    await player.play();
  }

  @override
  Future<void> stop() async {
    controller.playing.value=false;
    controller.playItem.value=null;
    controller.percent.value=0.0;
    playItem=null;
    player.stop();
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
      controls: [],
    ));
    await super.stop();
  }

  void dispose() async {
    player.stop();
    player.dispose();
  }
}