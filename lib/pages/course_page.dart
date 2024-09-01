import 'package:flutter/material.dart';

import '../widgets/course/lectures_widget.dart';

class CoursePage extends StatelessWidget {
  final String courseTitle;

  const CoursePage({required this.courseTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: LecturesWidget(
        courseTitle: courseTitle,
      ),
    );
  }
}
