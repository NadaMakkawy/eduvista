import 'package:flutter/material.dart';

import '../../models/category_item.dart';

import '../../utils/color_utilis.dart';

class SearchChipsListWidget extends StatelessWidget {
  const SearchChipsListWidget({
    super.key,
    required this.categories,
  });

  final List<CategoryItem> categories;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: categories.map(
        (category) {
          return Container(
            decoration: BoxDecoration(
              color: ColorUtility.grayExtraLight,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              category.name!,
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ).toList(),
    );
  }
}
