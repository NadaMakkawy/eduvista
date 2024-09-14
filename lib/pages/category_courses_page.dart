import 'package:flutter/material.dart';

import '../models/category_item.dart';

import '../utils/color_utilis.dart';

import '../widgets/home/courses_of_category_get_widget.dart';

class CategoryCoursesPage extends StatelessWidget {
  static const String id = 'CategoryCoursesPage';

  final CategoryItem category;

  const CategoryCoursesPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses in ${category.name}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ColorUtility.main,
          ),
        ),
      ),
      body: CoursesOfCategoryGetWidget(category: category),
    );
  }
}
