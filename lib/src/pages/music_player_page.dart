import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/bloc/song_selector_bloc.dart';
import 'package:music_player/src/models/audioplayer_provider.dart';
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
          final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
          return Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      const Background(),
                      Column(
                        children: [
                          const ScrollTrack(),
                          const SizedBox(height: 38),
                          if (state is ActiveMultiselectState)
                            GridZone(
                              key: const ValueKey('grid'),
                              audioPlayerProvider: audioPlayerProvider,
                            ),
                          if (state is DeactiveMultiselectState)
                            _DiscZone(
                              audioPlayerProvider: audioPlayerProvider,
                              key: const ValueKey('disc'), //Evita que se genere una nueva instancia del widget
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (state is DeactiveMultiselectState) const Expanded(child: Lyrics()),
                ],
              ),
              if (state is ActiveMultiselectState) const _ForCamilo()
            ],
          );
        },
      ),
    ));
  }
}

// class ItemOpacity extends StatelessWidget {
//   const ItemOpacity({Key? key, required this.show, required this.child}) : super(key: key);
//   final bool show;
//   final Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 400),
//       opacity: show ? 1 : 0.0,
//       child: child,
//     );
//   }
// }

class _ForCamilo extends StatelessWidget {
  const _ForCamilo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          'for Camilo',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

class _DiscZone extends StatelessWidget {
  const _DiscZone({
    Key? key,
    required this.audioPlayerProvider,
  }) : super(key: key);

  final AudioPlayerProvider audioPlayerProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const DiscoImage(),
              TitleTrack(songs: audioPlayerProvider.songs),
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
    );
  }
}

class GridZone extends StatelessWidget {
  const GridZone({
    Key? key,
    required this.audioPlayerProvider,
  }) : super(key: key);

  final AudioPlayerProvider audioPlayerProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              spacing: 12,
              runSpacing: 12,
              children: audioPlayerProvider.deletedSongs
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
    );
  }
}
