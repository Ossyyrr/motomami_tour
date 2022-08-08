part of 'song_selector_bloc.dart';

@immutable
abstract class SongSelectorState {
  final bool isMultiSelect;
  const SongSelectorState({required this.isMultiSelect});
}

class ActiveMultiselectState extends SongSelectorState {
  const ActiveMultiselectState() : super(isMultiSelect: true);
}

class DeactiveMultiselectState extends SongSelectorState {
  const DeactiveMultiselectState() : super(isMultiSelect: false);
}
