import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  // @override
  // Widget build(BuildContext context) {
  //   switch (widget.courseOption) {
  //     case CourseOptions.Lecture:
  //       return FutureBuilder(
  //           future: FirebaseFirestore.instance
  //               .collection('courses')
  //               .doc(widget.course.id)
  //               .collection('lectures')
  //               .get(),
  //           builder: (ctx, snapshot) {
  //             print('course Id ${widget.course.id}');
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(
  //                 child: CircularProgressIndicator(),
  //               );
  //             }
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  // if (snapshot.hasError) {
  //   return const Center(
  //     child: Text('Error occurred'),
  //   );
  // }

  @override
  void initState() {
    init();
    super.initState();
  }

  // if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
  //   return const Center(
  //     child: Text('No Lectures found'),
  //   );
  // }
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

  // var lectures = List<Lecture>.from(snapshot.data?.docs
  //         .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
  //         .toList() ??
  //     []);
  Lecture? selectedLecture;

  // return GridView.count(
  //   mainAxisSpacing: 15,
  //   crossAxisSpacing: 15,
  //   shrinkWrap: true,
  //   crossAxisCount: 2,
  //   children: List.generate(lectures.length, (index) {
  //     return InkWell(
  //       onTap: () => widget.onLectureChosen(lectures[index]),
  //       child: Container(
  //         padding: const EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //           color: const Color(0xffE0E0E0),
  //           borderRadius: BorderRadius.circular(40),
  //         ),
  //         child: Center(
  //           child: Text(lectures[index].title ?? 'No Name'),
  //         ),
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
              course: widget.course,
              courseOption: widget.courseOption,
              onLectureChosen: widget.onLectureChosen,
              selectedLecture: selectedLecture);
        }

      case CourseOptions.Download:
        return const SizedBox.shrink();

      case CourseOptions.Certificate:
        return const SizedBox.shrink();

      case CourseOptions.More:
        return const SizedBox.shrink();
      default:
        return Text('Invalid option ${widget.courseOption.name}');
    }
  }
}
