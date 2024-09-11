import 'package:eduvista/models/category_item.dart';
import 'package:eduvista/pages/category_courses_page.dart';
import 'package:flutter/material.dart';

class CategoriesHeaderWidget extends StatelessWidget {
  const CategoriesHeaderWidget({
    super.key,
    required this.categories,
  });

  final List<CategoryItem> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(
        width: 10,
      ),
      itemBuilder: (context, index) => InkWell(
        onTap: () async {
          // Todo add navigation to open new page has all courses related to this category
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryCoursesPage(
                category: categories[index],
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffE0E0E0),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(categories[index].name ?? 'No Name'),
          ),
        ),
      ),
    );
  }
}
