// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // import '../models/course.dart';

// // import '../widgets/course/course_card.dart';

// // class AllCategorisPage extends StatelessWidget {
// //   final Function(Course) onCourseClick;

// //   const AllCategorisPage({Key? key, required this.onCourseClick})
// //       : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Courses')),
// //       body: FutureBuilder(
// //         future: FirebaseFirestore.instance.collection('courses').get(),
// //         builder: (ctx, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           if (snapshot.hasError) {
// //             return const Center(child: Text('Error occurred'));
// //           }

// //           if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
// //             return const Center(child: Text('No courses found'));
// //           }

// //           var courses = List<Course>.from(snapshot.data?.docs
// //                   .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
// //                   .toList() ??
// //               []);

// //           return CourseCard(courses: courses, onCourseClick: onCourseClick);
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eduvista/utils/color_utilis.dart';
// import 'package:eduvista/widgets/course/course_card_widget.dart';
// import 'package:flutter/material.dart';

// import '../models/category.dart';
// import '../models/course.dart';
// import '../widgets/course/course_cards_List_widget.dart';

// // import '../widgets/course/course_card.dart';

// class AllCategorisPage extends StatelessWidget {
//   final List<String> mainCategories = ["Bussiness"];
//   final List<String> subCategories = [
//     "UI/UX",
//     "Accounts",
//     "Software Engineering",
//     "SEO"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     var futureCall = FirebaseFirestore.instance.collection('categories').get();

//     // return Scaffold(
//     //   appBar: AppBar(
//     //     leading: Icon(Icons.arrow_back_ios),
//     //     title: Text('Categories'),
//     //     actions: [
//     //       IconButton(
//     //         icon: Icon(Icons.shopping_cart_outlined),
//     //         onPressed: () {},
//     //       )
//     //     ],
//     //   ),
//     return Scaffold(
//       appBar: AppBar(title: Text('Categories')),
//       // body: FutureBuilder(
//       //   future: FirebaseFirestore.instance.collection('courses').get(),
//       //   builder: (ctx, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.waiting) {
//       //       return const Center(child: CircularProgressIndicator());
//       //     }

//       //     if (snapshot.hasError) {
//       //       return const Center(child: Text('Error occurred'));
//       //     }

//       //     if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
//       //       return const Center(child: Text('No courses found'));
//       //     }

//       //     var courses = List<Course>.from(snapshot.data?.docs
//       //             .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
//       //             .toList() ??
//       //         []);
//       body: FutureBuilder(
//         future: futureCall,
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('Error occurred'),
//             );
//           }

//           if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
//             return const Center(
//               child: Text('No categories found'),
//             );
//           }

//           var categories = List<Category>.from(snapshot.data?.docs
//                   .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
//                   .toList() ??
//               []);
//           return ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: categories.length,
//             separatorBuilder: (context, index) => const SizedBox(
//               width: 10,
//             ),
//             itemBuilder: (context, index) => Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Main Category Dropdown
//                   DropdownButtonFormField<String>(
//                     value: mainCategories[0],
//                     items: mainCategories.map((String category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       );
//                     }).toList(),
//                     onChanged: (value) {},
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       suffixIcon: Icon(Icons.arrow_forward_ios),
//                     ),
//                   ),
//                   SizedBox(height: 16.0),

//                   // Subcategory Dropdown
//                   DropdownButtonFormField<String>(
//                     value: subCategories[0],
//                     items: subCategories.map((String category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       );
//                     }).toList(),
//                     onChanged: (value) {},
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       suffixIcon: Icon(Icons.arrow_drop_down),
//                     ),
//                   ),
//                   SizedBox(height: 16.0),

//                   // Course GridView
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("UI/UX",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       TextButton(onPressed: () {}, child: Text("See All"))
//                     ],
//                   ),
//                   // SizedBox(
//                   //   height: 350,
//                   //   child: GridView.builder(
//                   //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   //       crossAxisCount: 2,
//                   //       crossAxisSpacing: 10,
//                   //       mainAxisSpacing: 10,
//                   //       childAspectRatio: 0.7,
//                   //     ),
//                   //     // itemCount: courses.length,
//                   //     itemCount: 2,
//                   //     itemBuilder: (context, index) {
//                   //       // return CourseCard(
//                   //       //     courses: courses[index], onCourseClick: onCourseClick);
//                   //       // return CourseCard(
//                   //       //   course: null,
//                   //       //   widget: null,
//                   //       //   isPurchased: null,
//                   //       //   isInCart: null,
//                   //       //   index: null,
//                   //       // );
//                   //     },
//                   //   ),
//                   // ),
//                   CourseCardsListWidget(
//                     courses: courses,
//                   ),
//                   SizedBox(height: 16.0),

//                   // Other Categories
//                   Expanded(
//                     child: ListView(
//                       children: subCategories.sublist(1).map((String category) {
//                         return ListTile(
//                           title: Text(category),
//                           trailing: Icon(Icons.arrow_forward_ios),
//                           onTap: () {},
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:eduvista/widgets/home/categories__expandable__list_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_item.dart';
import '../models/course.dart';

class AllCategorisPage extends StatefulWidget {
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
