import 'package:eduvista/options/course/certificate_option.dart';
import 'package:eduvista/options/course/more_option.dart';
import 'package:eduvista/utils/color_utilis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/course/course_bloc.dart';

import '../../utils/app_enums.dart';

import '../../models/course.dart';
import '../../models/lecture.dart';

import '../../options/course/lectures_option.dart';

class CourseOptionsWidgets extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;
  final void Function(Lecture) onLectureChosen;

  const CourseOptionsWidgets(
      {required this.courseOption,
      required this.course,
      required this.onLectureChosen,
      super.key});

  @override
  State<CourseOptionsWidgets> createState() => _CourseOptionsWidgetsState();
}

class _CourseOptionsWidgetsState extends State<CourseOptionsWidgets> {
  @override
  void initState() {
    init();
    super.initState();
  }

  List<Lecture>? lectures;

  bool isLoading = false;
  void init() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200), () async {});
    if (!mounted) return;
    lectures = await context.read<CourseBloc>().getLectures();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Lecture? selectedLecture;

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (lectures == null || (lectures!.isEmpty)) {
          return const Center(
            child: Text('No lectures found'),
          );
        } else {
          return LecturesOption(
              lectures: lectures,
              onLectureChosen: widget.onLectureChosen,
              selectedLecture: selectedLecture);
        }

      case CourseOptions.Download:
        return const SizedBox.shrink();

      case CourseOptions.Certificate:
        // showCertificate(context);
        return widget.course.has_certificate == true
            ? Center(
                child: ElevatedButton(
                  onPressed: () {
                    showCertificate(context, widget.course.title!);
                  },
                  child: Text('Show Certificate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtility.deepYellow,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text('This Course doesn\'t have a Certificate'),
              );

      case CourseOptions.More:
        return MoreOption();
      default:
        return Text('Invalid option ${widget.courseOption.name}');
    }
  }
}
