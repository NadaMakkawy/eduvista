import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/lecture.dart';

part 'lecture_event.dart';
part 'lecture_state.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  LectureBloc() : super(LectureInitial()) {
    on<LectureChosenEvent>(_onLectureChosen);

    on<LectureEventInitial>((event, emit) {
      emit(LectureInitial());
    });
  }
  FutureOr<void> _onLectureChosen(
      LectureChosenEvent event, Emitter<LectureState> emit) {
    emit(LectureChosenState(event.lecture));
  }
}
