import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/course.dart';
import './course_card_widget.dart';
import '../../models/cart_item.dart';
import '../../cubit/cart/cart_cubit.dart';

class CourseCardsListWidget extends StatefulWidget {
  const CourseCardsListWidget({
    super.key,
    required this.courses,
    required this.useFixedCrossAxisCount,
  });

  final List<Course> courses;
  final bool useFixedCrossAxisCount;

  @override
  State<CourseCardsListWidget> createState() => _CourseCardsListWidgetState();
}

class _CourseCardsListWidgetState extends State<CourseCardsListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<CartItem>>(
      builder: (context, cartItems) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: widget.useFixedCrossAxisCount
              ? SizedBox(
                  height: 250,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: widget.courses.length,
                    itemBuilder: (context, index) {
                      final course = widget.courses[index];

                      return FutureBuilder<Map<String, bool>>(
                        future: _getCourseStatus(context, course.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(child: Text('Error occurred'));
                          }

                          final isPurchased =
                              snapshot.data?['isPurchased'] ?? false;
                          final isInCart = snapshot.data?['isInCart'] ?? false;

                          return CourseCard(
                            course: course,
                            widget: widget,
                            isPurchased: isPurchased,
                            isInCart: isInCart,
                            index: index,
                            courses: widget.courses,
                          );
                        },
                      );
                    },
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  childAspectRatio: 0.7,
                  children: List.generate(widget.courses.length, (index) {
                    final course = widget.courses[index];

                    return FutureBuilder<Map<String, bool>>(
                      future: _getCourseStatus(context, course.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(child: Text('Error occurred'));
                        }

                        final isPurchased =
                            snapshot.data?['isPurchased'] ?? false;
                        final isInCart = snapshot.data?['isInCart'] ?? false;

                        return CourseCard(
                          course: course,
                          widget: widget,
                          isPurchased: isPurchased,
                          isInCart: isInCart,
                          index: index,
                          courses: widget.courses,
                        );
                      },
                    );
                  }),
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
    return {'isPurchased': isPurchased, 'isInCart': isInCart};
  }
}
