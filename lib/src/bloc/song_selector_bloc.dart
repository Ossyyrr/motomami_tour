import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'song_selector_event.dart';
part 'song_selector_state.dart';

class SongSelectorBloc extends Bloc<SongSelectorEvent, SongSelectorState> {
  SongSelectorBloc() : super(const DeactiveMultiselectState()) {
    on<ChangeMultiSelect>((event, emit) {
      if (event.isMultiSelect) {
        emit(const ActiveMultiselectState());
      } else {
        emit(const DeactiveMultiselectState());
      }
    });
  }
}
