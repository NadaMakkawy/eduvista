import 'package:eduvista/pages/pending_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/course.dart';

import '../utils/image_utility.dart';

import '../widgets/home/course_filter_chips_widget.dart';
import '../widgets/course/course_tile_list_widget.dart';

import 'cart_page.dart';

class PurchasedCoursesPage extends StatelessWidget {
  static const String id = 'PurchasedCourses';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Courses',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, PendingCartPage.id);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('courses').get(),
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

          return Column(
            children: [
              CourseFilterChipsWidget(),
              CourseTileListWidget(courses: courses),
            ],
          );
        },
      ),
    );
  }
}
