part of 'lecture_bloc.dart';

@immutable
sealed class LectureEvent {}

class LectureEventInitial extends LectureEvent {}

class LectureChosenEvent extends LectureEvent {
  final Lecture lecture;
  LectureChosenEvent(this.lecture);
}
