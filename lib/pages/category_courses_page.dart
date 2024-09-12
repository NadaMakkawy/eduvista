import 'package:flutter/material.dart';

import '../models/category_item.dart';

import '../widgets/home/courses_of_category_get_widget.dart';

class CategoryCoursesPage extends StatelessWidget {
  final CategoryItem category;

  const CategoryCoursesPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Courses in ${category.name}')),
      body: CoursesOfCategoryGetWidget(category: category),
    );
  }
}
