import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/bloc/song_selector_bloc.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/models/song_model.dart';
import 'package:provider/provider.dart';

class Track extends StatelessWidget {
  const Track({
    Key? key,
    required this.song,
    required this.index,
    this.isDeletedSong = false,
  }) : super(key: key);
  final Song song;
  final int index;
  final bool isDeletedSong;
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    bool isSelected = audioPlayerModel.currentSong == index;
    return GestureDetector(
      onTap: () {
        final songSelector = BlocProvider.of<SongSelectorBloc>(context, listen: false);

        if (songSelector.state.isMultiSelect) {
          if (isDeletedSong) {
            audioPlayerModel.addSong(song);
          } else {
            audioPlayerModel.deleteSong(song);
          }
        } else {
          final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
          audioPlayerModel.currentSong = index;
          audioPlayerModel.assetAudioPlayer.playlistPlayAtIndex(index);
          print('TRACK: ' + song.title);
        }
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: isSelected ? 1 : 0.8,
        alignment: Alignment.topCenter,
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [
                  isSelected ? const Color(0xffec3f41) : const Color(0xff484750),
                  const Color(0xff1E1C24),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image(
                  height: 85,
                  width: 100,
                  image: AssetImage('assets/${song.image}'),
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      song.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
