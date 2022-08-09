import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/bloc/song_selector_bloc.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/background.dart';
import 'package:music_player/src/widgets/disco_image.dart';
import 'package:music_player/src/widgets/lyrics.dart';
import 'package:music_player/src/widgets/play_button.dart';
import 'package:music_player/src/widgets/progress_bar.dart';
import 'package:music_player/src/widgets/scroll_track.dart';
import 'package:music_player/src/widgets/title_track.dart';
import 'package:music_player/src/widgets/track.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: BlocBuilder<SongSelectorBloc, SongSelectorState>(
        builder: (context, state) {
          final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
          return Column(
            children: [
              Stack(
                children: [
                  const Background(),
                  Column(
                    children: [
                      const ScrollTrack(),
                      const SizedBox(height: 38),
                      if (state is ActiveMultiselectState)
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height - 200,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(38.0),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: audioPlayerModel.deletedSongs
                                      .asMap()
                                      .map(
                                        (i, song) => MapEntry(
                                          i,
                                          SizedBox(
                                              height: 120,
                                              child: Track(
                                                song: song,
                                                index: i,
                                                isDeletedSong: true,
                                              )),
                                        ),
                                      )
                                      .values
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (state is DeactiveMultiselectState)
                        SizedBox(
                          height: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const DiscoImage(),
                                  TitleTrack(songs: audioPlayerModel.songs),
                                ],
                              ),
                              const SizedBox(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  ProgressBar(),
                                  PlayButton(),
                                ],
                              ),
                              const SizedBox(),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (state is DeactiveMultiselectState) const Expanded(child: Lyrics()),
            ],
          );
        },
      ),
    ));
  }
}
