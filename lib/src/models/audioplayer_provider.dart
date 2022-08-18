import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/get_it.dart';
import 'package:music_player/src/helpers/motomami_disk.dart';
import 'package:music_player/src/helpers/tour_songs.dart';
import 'package:music_player/src/models/song_model.dart';

class AudioPlayerProvider with ChangeNotifier {
  AudioPlayerProvider() {
    songs = getMotomamiSongs();
    deletedSongs = getTourSongs();
  }
  late final List<Song> songs;
  late final List<Song> deletedSongs;

  int _currentSong = 0;
  var assetAudioPlayer = getIt.get<AssetsAudioPlayer>();
  bool _playing = false;

  late AnimationController playAnimation;

  // String get songTotalDuration => printDuration(songDuration);
  // String get currentSecond => printDuration(current);

  // double get porcentaje => (songDuration.inSeconds > 0) ? _current.inSeconds / _songDuration.inSeconds : 0;

  late AnimationController _imageDiscoController;
  AnimationController get imageDiscoController => _imageDiscoController;
  set imageDiscoController(AnimationController valor) {
    _imageDiscoController = valor;
  }

  int get currentSong => _currentSong;
  set currentSong(int valor) {
    _currentSong = valor % songs.length;
    notifyListeners();
  }

  bool get playing => _playing;

  set playing(bool valor) {
    _playing = valor;
    notifyListeners();
  }

  // Duration get songDuration => _songDuration;
  // set songDuration(Duration valor) {
  //   _songDuration = valor;
  //   notifyListeners();
  // }

  // Duration get current => _current;
  // set current(Duration valor) {
  //   _current = valor;
  //   //  notifyListeners();
  // }

  // String printDuration(Duration duration) {
  //   String twoDigits(int n) {
  //     if (n >= 10) return "$n";
  //     return "0$n";
  //   }

  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "$twoDigitMinutes:$twoDigitSeconds";
  // }

  List<Song> getMotomamiSongs() {
    List<Song> songList = [];
    for (var song in motomamiDisk) {
      songList.add(Song.fromMap(song));
    }
    return songList;
  }

  List<Song> getTourSongs() {
    List<Song> songList = [];
    for (var song in tourSongs) {
      songList.add(Song.fromMap(song));
    }
    return songList;
  }

  void open() {
    List<Audio> audios = [];

    for (var song in songs) {
      audios.add(Audio(song.mp3));
    }
    assetAudioPlayer.open(
      Playlist(audios: audios),
      loopMode: LoopMode.playlist,
      autoStart: false,
    );
    listeners();
  }

  void onPressedMultiselectButton() {
    assetAudioPlayer.stop();
    currentSong = 0;
  }

  void listeners() {
    // no puedo poner un notifiListeners dentro del listener de duration,
    // porque la aplicación se pilla al tiempo por notificar tantas veces
    // final periodicTimer = Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer) {
    //     notifyListeners();
    //   },
    // );

    // assetAudioPlayer.currentPosition.listen((duration) {
    //   current = duration;
    // });

    // assetAudioPlayer.current.listen((playingAudio) {
    //   songDuration = playingAudio?.audio.duration ?? const Duration(seconds: 0);
    // });

    assetAudioPlayer.playlistAudioFinished.listen((event) {
      _currentSong++;
    });
  }

  void onTapPlay() {
    if (playing) {
      playAnimation.reverse(); // icono play
      imageDiscoController.stop(); // imagen disco
      assetAudioPlayer.pause(); // musica
      playing = false;
    } else {
      playAnimation.forward(); // icono play
      imageDiscoController.repeat(); // imagen disco
      assetAudioPlayer.play(); // musica
      playing = true;
    }
    notifyListeners();
  }

  void onTapTrack() {
    playAnimation.forward(); // icono play
    imageDiscoController.repeat(); // imagen disco
    assetAudioPlayer.play(); // musica
    playing = true;
    notifyListeners();
  }

  void addSong(Song song) {
    deletedSongs.remove(song);
    songs.insert(0, song);
    _currentSong = 0;
    notifyListeners();
  }

  void deleteSong(Song song) {
    songs.remove(song);
    deletedSongs.insert(0, song);
    _currentSong = 0;
    notifyListeners();
  }
}
