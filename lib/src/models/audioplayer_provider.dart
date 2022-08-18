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
    listeners();
  }
  late final List<Song> songs;
  late final List<Song> deletedSongs;

  int _currentSong = 0;
  var assetAudioPlayer = getIt.get<AssetsAudioPlayer>();
  bool _playing = false;

  late AnimationController playAnimation;

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
  }

  void onPressedMultiselectButton() {
    assetAudioPlayer.stop();
    currentSong = 0;
  }

  void listeners() {
    assetAudioPlayer.playlistAudioFinished.listen((event) {
      currentSong++;
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
