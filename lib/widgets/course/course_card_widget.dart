import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';

import '../../widgets/course/rating_display_widget.dart';
import '../../widgets/course/course_cards_List_widget.dart';

import '../../utils/color_utilis.dart';

import '../../cubit/cart/cart_cubit.dart';

import '../../pages/course_details_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final CourseCardsListWidget widget;
  final bool isPurchased;
  final bool isInCart;
  final int index;
  final List<Course> courses;

  const CourseCard({
    super.key,
    required this.course,
    required this.widget,
    required this.isPurchased,
    required this.isInCart,
    required this.index,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CourseDetailsPage.id, arguments: course);

        clickedCourses(context, course);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                course.image ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        course.rating.toString(),
                        style:
                            TextStyle(fontSize: 14, color: ColorUtility.gray),
                      ),
                      SizedBox(width: 5),
                      RatingDisplay(rating: courses[index].rating!),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    course.title ?? 'No Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_outlined,
                        color: ColorUtility.gray,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        course.instructor?.name ?? 'No Instructor',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${course.price?.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorUtility.main,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      isPurchased
                          ? Text(
                              'Purchased',
                              style: TextStyle(color: Colors.green),
                            )
                          : isInCart
                              ? Text(
                                  'In Cart',
                                  style:
                                      TextStyle(color: ColorUtility.deepYellow),
                                )
                              : GestureDetector(
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: ColorUtility.main,
                                      size: 18,
                                    ),
                                  ),
                                  onTap: () {
                                    context.read<CartCubit>().addToCart(course);
                                  },
                                ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> clickedCourses(BuildContext context, Course course) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('clicked_courses')
        .doc(course.id)
        .set(
      {
        'course_id': course.id,
        'title': course.title,
        'price': course.price,
        'image': course.image,
        'rating': course.rating,
        'instructor': course.instructor?.name,
      },
    );
  }
}
