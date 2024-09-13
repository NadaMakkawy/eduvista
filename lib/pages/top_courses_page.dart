import 'package:flutter/material.dart';

import '../widgets/home/top_courses_get_widget.dart';

class TopCoursesPage extends StatelessWidget {
  static const String id = 'TopCoursesPage';

  final String? rankValue;

  const TopCoursesPage({
    Key? key,
    required this.rankValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${rankValue != null ? '${rankValue}' : 'Courses'}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TopCoursesGetWidget(rankValue: rankValue),
      ),
    );
  }
}
