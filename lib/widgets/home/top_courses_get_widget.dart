import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';

import '../../utils/image_utility.dart';

import '../../widgets/course/course_cards_List_widget.dart';

class TopCoursesGetWidget extends StatelessWidget {
  const TopCoursesGetWidget({
    super.key,
    required this.rankValue,
  });

  final String? rankValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('courses')
          .where('rank', isEqualTo: rankValue)
          .get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error occurred'));
        }

        if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
          return Center(child: Image.asset(IntroImageUtils.error));
        }

        var courses = List<Course>.from(snapshot.data?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        return CourseCardsListWidget(
          courses: courses,
          useFixedCrossAxisCount: false,
        );
      },
    );
  }
}
