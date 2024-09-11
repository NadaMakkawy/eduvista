// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvista/models/course.dart';
import 'package:eduvista/widgets/course/course_cards_List_widget.dart';
import 'package:flutter/material.dart';

class TopCoursesGetWidget extends StatelessWidget {
  const TopCoursesGetWidget({
    super.key,
    required this.rankValue,
  });

  final String rankValue;

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
          return const Center(child: Text('No courses found'));
        }

        var courses = List<Course>.from(snapshot.data?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        return CourseCardsListWidget(
          courses: courses,
        );
      },
    );
  }
}
