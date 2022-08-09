part of 'song_selector_bloc.dart';

@immutable
abstract class SongSelectorEvent {}

class ChangeMultiSelect extends SongSelectorEvent {
  final bool isMultiSelect;
  ChangeMultiSelect({required this.isMultiSelect});
}
