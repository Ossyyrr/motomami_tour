import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/bloc/song_selector_bloc.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/track.dart';
import 'package:provider/provider.dart';

class ScrollTrack extends StatelessWidget {
  const ScrollTrack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return SizedBox(
        height: 120,
        width: double.infinity,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: audioPlayerModel.songs.length + 1,
          itemBuilder: (context, index) {
            if (index != audioPlayerModel.songs.length) {
              return Track(song: audioPlayerModel.songs[index], index: index);
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 44, right: 8),
                child: IconButton(
                  icon: const Icon(Icons.apps),
                  onPressed: () {
                    final songSelector = BlocProvider.of<SongSelectorBloc>(context, listen: false);
                    songSelector.add(ChangeMultiSelect(isMultiSelect: !songSelector.state.isMultiSelect));
                  },
                ),
              );
            }
          },
        ));
  }
}
