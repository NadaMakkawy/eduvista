import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import '../../models/category_item.dart';

import '../../widgets/course/course_cards_List_widget.dart';

class CoursesOfCategoryGetWidget extends StatelessWidget {
  const CoursesOfCategoryGetWidget({
    super.key,
    required this.category,
  });

  final CategoryItem category;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('courses')
          .where('category.id', isEqualTo: category.id)
          .get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error occurred'));
        }

        if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
          return const Center(child: Text('No courses found'));
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
