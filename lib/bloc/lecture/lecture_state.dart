part of 'lecture_bloc.dart';

@immutable
sealed class LectureState {}

final class LectureInitial extends LectureState {}

class LectureChosenState extends LectureState {
  final Lecture lecture;
  LectureChosenState(this.lecture);
}
