import 'package:flutter/material.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:provider/provider.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
    audioPlayerModel.playAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((_) => audioPlayerModel.open());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () {
            audioPlayerModel.onTapPlay();
          },
          onHorizontalDragEnd: (DragEndDetails drag) {
            if (drag.primaryVelocity == null) return;
            if (drag.primaryVelocity! < 0) {
              // drag from right to left
              audioPlayerModel.assetAudioPlayer.previous().then(
                  (value) => audioPlayerModel.currentSong = audioPlayerModel.assetAudioPlayer.current.value!.index);
            } else {
              // drag from left to right
              audioPlayerModel.assetAudioPlayer.next().then(
                  (value) => audioPlayerModel.currentSong = audioPlayerModel.assetAudioPlayer.current.value!.index);
            }
          },
          child: Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                color: const Color(0xff201e28),
                progress: audioPlayerModel.playAnimation,
              )),
        ));
  }
}
