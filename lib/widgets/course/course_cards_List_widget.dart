import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvista/cubit/cart/cart_cubit.dart';
import 'package:eduvista/models/course.dart';
import 'package:eduvista/pages/course_details_page.dart';
import 'package:eduvista/utils/color_utilis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/cart_item.dart';

// class CourseCardsListWidget extends StatefulWidget {
//   const CourseCardsListWidget({
//     super.key,
//     required this.courses,
//     required this.onCourseClick,
//   });

//   final List<Course> courses;
//   final Function(Course) onCourseClick;

//   @override
//   State<CourseCardsListWidget> createState() => _CourseCardsListWidgetState();
// }

// class _CourseCardsListWidgetState extends State<CourseCardsListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 250.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           final course = widget.courses[index];

//           return FutureBuilder<bool>(
//             future: context.read<CartCubit>().isCoursePurchased(course.id!),
//             builder: (context, purchaseSnapshot) {
//               if (purchaseSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (purchaseSnapshot.hasError) {
//                 return const Center(child: Text('Error occurred'));
//               }

//               final isPurchased = purchaseSnapshot.data ?? false;

//               // Now check if the course is in the cart
//               return FutureBuilder<bool>(
//                 future: context.read<CartCubit>().isInCart(course.id!),
//                 builder: (context, cartSnapshot) {
//                   if (cartSnapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (cartSnapshot.hasError) {
//                     return const Center(child: Text('Error occurred'));
//                   }

//                   final isInCart = cartSnapshot.data ?? false;

//                   return InkWell(
//                     onTap: () async {
//                       await FirebaseFirestore.instance
//                           .collection('courses')
//                           .doc(widget.courses[index].id)
//                           .update({'is_clicked': true});

//                       widget.courses[index].is_clicked = true;

//                       widget.onCourseClick(widget.courses[index]);
//                       Navigator.pushNamed(context, CourseDetailsPage.id,
//                           arguments: widget.courses[index]);
//                     },
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 100.h,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(40),
//                             child: Image.network(
//                               widget.courses[index].image ?? 'No Image',
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(widget.courses[index].instructor?.name ??
//                             'No Instructor'),
//                         const SizedBox(height: 10),
//                         Text(widget.courses[index].title ?? 'No Title'),
//                         const SizedBox(height: 10),
//                         Text(
//                             '\$${widget.courses[index].price?.toStringAsFixed(2)}'),
//                         // const SizedBox(height: 10),
//                         // Text('Duration: ${courses[index].duration?? '0'} hours'),
//                         const SizedBox(height: 10),
//                         //   ElevatedButton(
//                         //     onPressed: () {
//                         //       context.read<CartCubit>().addToCart(courses[index]);
//                         //     },
//                         //     child: const Text('Add to Cart'),
//                         //   ),

//                         // Show the Add to Cart button only if the course is not purchased
//                         isPurchased
//                             ? Text(
//                                 'Purchased',
//                                 style: TextStyle(color: Colors.green),
//                               )
//                             : isInCart
//                                 ? Text(
//                                     'In Cart',
//                                     style: TextStyle(
//                                         color: ColorUtility.deepYellow),
//                                   )
//                                 : ElevatedButton(
//                                     onPressed: () {
//                                       context
//                                           .read<CartCubit>()
//                                           .addToCart(course);
//                                     },
//                                     child: const Text('Add to Cart'),
//                                   ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//         itemCount: widget.courses.length,
//       ),
//     );
//   }
// }
class CourseCardsListWidget extends StatefulWidget {
  const CourseCardsListWidget({
    super.key,
    required this.courses,
    // required this.onCourseClick,
  });

  final List<Course> courses;
  // final Function(Course) onCourseClick;

  @override
  State<CourseCardsListWidget> createState() => _CourseCardsListWidgetState();
}

class _CourseCardsListWidgetState extends State<CourseCardsListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<CartItem>>(
      // Rebuild when CartCubit state changes
      builder: (context, cartItems) {
        return SizedBox(
          height: 250.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final course = widget.courses[index];

              return FutureBuilder<Map<String, bool>>(
                future:
                    _getCourseStatus(context, course.id!), // Fetch both states
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error occurred'));
                  }

                  final isPurchased = snapshot.data?['isPurchased'] ?? false;
                  final isInCart = snapshot.data?['isInCart'] ?? false;

                  return InkWell(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('courses')
                          .doc(course.id)
                          .update({'is_clicked': true});

                      // widget.courses[index].is_clicked = true;

                      // widget.onCourseClick(widget.courses[index]);
                      Navigator.pushNamed(context, CourseDetailsPage.id,
                          arguments: widget.courses[index]);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              course.image ?? 'No Image',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(course.instructor?.name ?? 'No Instructor'),
                        const SizedBox(height: 10),
                        Text(course.title ?? 'No Title'),
                        const SizedBox(height: 10),
                        Text('\$${course.price?.toStringAsFixed(2)}'),
                        const SizedBox(height: 10),
                        isPurchased
                            ? const Text(
                                'Purchased',
                                style: TextStyle(color: Colors.green),
                              )
                            : isInCart
                                ? Text(
                                    'In Cart',
                                    style: TextStyle(
                                        color: ColorUtility.deepYellow),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<CartCubit>()
                                          .addToCart(course);
                                    },
                                    child: const Text('Add to Cart'),
                                  ),
                      ],
                    ),
                  );
                },
              );
            },
            itemCount: widget.courses.length,
          ),
        );
      },
    );
  }

  Future<Map<String, bool>> _getCourseStatus(
      BuildContext context, String courseId) async {
    final isPurchased =
        await context.read<CartCubit>().isCoursePurchased(courseId);
    final isInCart = await context.read<CartCubit>().isInCart(courseId);
    return {
      'isPurchased': isPurchased,
      'isInCart': isInCart
    }; // Return both as a map
  }
}
