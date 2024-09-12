import 'package:flutter/material.dart';

import '../widgets/home/top_courses_get_widget.dart';

class TopCoursesPage extends StatelessWidget {
  final String? rankValue;

  const TopCoursesPage({
    Key? key,
    required this.rankValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$rankValue Courses')),
      body: TopCoursesGetWidget(rankValue: rankValue ?? 'All'),
    );
  }
}
