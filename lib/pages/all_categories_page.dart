import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/course.dart';
import '../models/category_item.dart';

import '../widgets/home/categories_expandable_list_widget.dart';

class AllCategorisPage extends StatefulWidget {
  static const String id = 'AllCategorisPage';

  @override
  _AllCategorisPageState createState() => _AllCategorisPageState();
}

class _AllCategorisPageState extends State<AllCategorisPage> {
  CategoryItem? selectedCategory;
  Future<List<Course>>? futureCourses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          }

          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return const Center(child: Text('No categories found'));
          }

          var categories = List<CategoryItem>.from(snapshot.data?.docs
                  .map((e) => CategoryItem.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];

              return CategoriesExpandableListWidget(
                categories: categories,
                category: category,
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
