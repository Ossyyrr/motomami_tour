import 'package:flutter/material.dart';
import 'package:music_player/src/models/audioplayer_provider.dart';
import 'package:provider/provider.dart';

class Lyrics extends StatelessWidget {
  const Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    return ListWheelScrollView(
        physics: const BouncingScrollPhysics(),
        itemExtent: 40,
        diameterRatio: 2,
        children: audioPlayerProvider.songs[audioPlayerProvider.currentSong].lyrics
            .map((linea) => SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        linea,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 20),
                      ),
                    ),
                  ),
                ))
            .toList());
  }
}
