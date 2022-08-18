import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/get_it.dart';
import 'package:music_player/src/bloc/song_selector_bloc.dart';
import 'package:music_player/src/models/audioplayer_provider.dart';
import 'package:music_player/src/pages/music_player_page.dart';
import 'package:music_player/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setup();
    return MultiBlocProvider(
      providers: [
        BlocProvider<SongSelectorBloc>(create: (_) => SongSelectorBloc()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music player',
          theme: miTema,
          home: const MusicPlayerPage(),
        ),
      ),
    );
  }
}
