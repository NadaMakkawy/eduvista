import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../models/lecture.dart';

import '../../utils/app_enums.dart';
import '../../utils/color_utilis.dart';

class LecturesOption extends StatefulWidget {
  final List<Lecture>? lectures;
  final CourseOptions courseOption;
  final Course course;
  final void Function(Lecture) onLectureChosen;
  Lecture? selectedLecture;

  LecturesOption(
      {required this.lectures,
      required this.course,
      required this.courseOption,
      required this.onLectureChosen,
      required this.selectedLecture,
      super.key});

  @override
  State<LecturesOption> createState() => _LecturesOptionState();
}

class _LecturesOptionState extends State<LecturesOption> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(
        widget.lectures!.length,
        (index) {
          return InkWell(
            onTap: () {
              widget.onLectureChosen(widget.lectures![index]);
              widget.selectedLecture = widget.lectures![index];
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.selectedLecture?.id == widget.lectures![index].id
                    ? ColorUtility.deepYellow
                    : const Color(0xffE0E0E0),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  widget.lectures![index].title ?? 'No Title',
                  style: TextStyle(
                      color: widget.selectedLecture?.id ==
                              widget.lectures![index].id
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
