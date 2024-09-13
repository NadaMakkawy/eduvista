import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';

import 'course_cards_List_widget.dart';

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
      onTap: () async {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(course.id)
            .update({'is_clicked': true});

        Navigator.pushNamed(context, CourseDetailsPage.id,
            arguments: widget.courses[index]);
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
                      _RatingDisplay(rating: widget.courses[index].rating!),
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
}

class _RatingDisplay extends StatelessWidget {
  final double rating;

  _RatingDisplay({required this.rating});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating % 1 >= 0.5;

    return Row(
      children: [
        ...List.generate(
            fullStars,
            (index) => Icon(
                  Icons.star,
                  color: ColorUtility.main,
                  size: 16,
                )),
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            color: ColorUtility.main,
            size: 16,
          ),
        ...List.generate(
            5 - fullStars - (hasHalfStar ? 1 : 0),
            (index) => Icon(
                  Icons.star_border,
                  color: ColorUtility.main,
                  size: 16,
                )),
      ],
    );
  }
}
