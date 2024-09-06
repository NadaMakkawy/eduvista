import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/cart/cart_cubit.dart';

import '../../pages/course_details_page.dart';

import '../../models/course.dart';

class CoursesWidget extends StatefulWidget {
  final String? rankValue;
  final Function(Course) onCourseClick;

  const CoursesWidget(
      {required this.onCourseClick, required this.rankValue, super.key});

  @override
  State<CoursesWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rankValue)
        .orderBy('created_date', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCall,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error occurred'),
          );
        }

        if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
          return const Center(
            child: Text('No categories found'),
          );
        }

        var courses = List<Course>.from(snapshot.data?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        return SizedBox(
          height: 250.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(courses[index].id)
                      .update({'is_clicked': true});

                  courses[index].is_clicked = true;

                  widget.onCourseClick(courses[index]);
                  Navigator.pushNamed(context, CourseDetailsPage.id,
                      arguments: courses[index]);
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          courses[index].image ?? 'No Image',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(courses[index].instructor?.name ?? 'No Instructor'),
                    const SizedBox(height: 10),
                    Text(courses[index].title ?? 'No Title'),
                    const SizedBox(height: 10),
                    Text('\$${courses[index].price?.toStringAsFixed(2)}'),
                    // const SizedBox(height: 10),
                    // Text('Duration: ${courses[index].duration?? '0'} hours'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartCubit>().addToCart(courses[index]);
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              );
            },
            itemCount: courses.length,
          ),
        );
      },
    );
  }
}
