part of 'course_bloc.dart';

@immutable
sealed class CourseEvent {}

class CourseFetchEvent extends CourseEvent {
  final Course course;

  CourseFetchEvent(this.course);
}

class CourseOptionChosenEvent extends CourseEvent {
  final CourseOptions courseOptions;

  CourseOptionChosenEvent(this.courseOptions);
}
