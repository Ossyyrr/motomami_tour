import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/bloc/song_selector_bloc.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songSelector = BlocProvider.of<SongSelectorBloc>(context);

    return BlocBuilder<SongSelectorBloc, SongSelectorState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: double.infinity,
          height: songSelector.state.isMultiSelect
              ? MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom
              : 565,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [
                Color(0xff33333e),
                Color(0xff201e28),
              ],
            ),
          ),
        );
      },
    );
  }
}
