// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvista/models/category_item.dart';
import 'package:eduvista/models/course.dart';
import 'package:eduvista/widgets/course/course_cards_List_widget.dart';
import 'package:flutter/material.dart';

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

        // return SizedBox(
        //   height: 250.h,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //       final course = courses[index];

        //       return FutureBuilder<bool>(
        //         future:
        //             context.read<CartCubit>().isCoursePurchased(course.id!),
        //         builder: (context, purchaseSnapshot) {
        //           if (purchaseSnapshot.connectionState ==
        //               ConnectionState.waiting) {
        //             return const Center(child: CircularProgressIndicator());
        //           }

        //           // If there was an error checking purchase status
        //           if (purchaseSnapshot.hasError) {
        //             return const Center(child: Text('Error occurred'));
        //           }

        //           final isPurchased = purchaseSnapshot.data ?? false;

        //           return InkWell(
        //             onTap: () async {
        //               await FirebaseFirestore.instance
        //                   .collection('courses')
        //                   .doc(course.id)
        //                   .update({'is_clicked': true});

        //               course.is_clicked = true;

        //               // Trigger the course click callback
        //               // Navigator.pushNamed(context, CourseDetailsPage.id,
        //               //     arguments: course);
        //             },
        //             child: Column(
        //               children: [
        //                 SizedBox(
        //                   height: 100.h,
        //                   child: ClipRRect(
        //                     borderRadius: BorderRadius.circular(40),
        //                     child: Image.network(
        //                       course.image ?? 'No Image',
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ),
        //                 const SizedBox(height: 20),
        //                 Text(course.instructor?.name ?? 'No Instructor'),
        //                 const SizedBox(height: 10),
        //                 Text(course.title ?? 'No Title'),
        //                 const SizedBox(height: 10),
        //                 Text('\$${course.price?.toStringAsFixed(2)}'),

        //                 // Show the Add to Cart button only if the course is not purchased
        //                 if (!isPurchased)
        //                   ElevatedButton(
        //                     onPressed: () {
        //                       context.read<CartCubit>().addToCart(course);
        //                     },
        //                     child: const Text('Add to Cart'),
        //                   )
        //                 else
        //                   const Text('Purchased',
        //                       style: TextStyle(color: Colors.green)),
        //               ],
        //             ),
        //           );
        //         },
        //       );
        //     },
        //     itemCount: courses.length,
        //   ),
        // );
        return CourseCardsListWidget(
          courses: courses,
        );
      },
    );
  }
}
