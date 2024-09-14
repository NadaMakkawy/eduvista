import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/category_item.dart';

import '../../pages/category_courses_page.dart';

import '../../utils/color_utilis.dart';
import '../../utils/image_utility.dart';

class SearchChipsListWidget extends StatelessWidget {
  const SearchChipsListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var futureCall = FirebaseFirestore.instance.collection('categories').get();

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
          return Center(child: Image.asset(IntroImageUtils.error));
        }

        var categories = List<CategoryItem>.from(snapshot.data?.docs
                .map((e) => CategoryItem.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: categories.map(
            (category) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CategoryCoursesPage(
                        category: category,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorUtility.grayExtraLight,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    category.name!,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
