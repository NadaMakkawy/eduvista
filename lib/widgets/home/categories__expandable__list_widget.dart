// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eduvista/models/category_item.dart';
// import 'package:eduvista/models/course.dart';
// import 'package:eduvista/pages/category_courses_page.dart';
// import 'package:eduvista/utils/color_utilis.dart';
// import 'package:eduvista/widgets/course/course_cards_List_widget.dart';
// import 'package:eduvista/widgets/home/label_widget.dart';
// import 'package:flutter/material.dart';

// class Categories_Expandable_List_widget extends StatelessWidget {
//   const Categories_Expandable_List_widget({
//     super.key,
//     required this.categories,
//     required this.category,
//     required this.index,
//   });

//   final List<CategoryItem> categories;
//   final CategoryItem category;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text(categories[index].name ?? 'No Name'),
//       collapsedBackgroundColor: ColorUtility.grayLight,
//       backgroundColor: Colors.white,
//       children: [
//         FutureBuilder(
//           future: FirebaseFirestore.instance
//               .collection('courses')
//               .where('category.id', isEqualTo: category.id)
//               .get(),
//           builder: (ctx, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return const Center(child: Text('Error occurred'));
//             }

//             if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
//               return const Center(child: Text('No courses found'));
//             }

//             var courses = List<Course>.from(snapshot.data?.docs
//                     .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
//                     .toList() ??
//                 []);
//             // FutureBuilder<List<Course>>(
//             //   future: FirebaseFirestore.instance
//             //       .collection('courses')
//             //       .where('categoryId',
//             //           isEqualTo: categories[index]
//             //               .id) // Adjust based on your structure
//             //       .get()
//             //       .then((snapshot) => List<Course>.from(snapshot.docs
//             //           .map((e) =>
//             //               Course.fromJson({'id': e.id, ...e.data()}))
//             //           .toList())),
//             //   builder: (ctx, courseSnapshot) {
//             //     if (courseSnapshot.connectionState ==
//             //         ConnectionState.waiting) {
//             //       return const Center(child: CircularProgressIndicator());
//             //     }

//             //     if (courseSnapshot.hasError) {
//             //       return const Center(child: Text('Error occurred'));
//             //     }

//             //     if (!courseSnapshot.hasData ||
//             //         (courseSnapshot.data?.isEmpty ?? false)) {
//             //       return const ListTile(title: Text('No courses found'));
//             //     }

//             //     var courses = courseSnapshot.data!;

//             // return Column(
//             //   children: courses.map((course) {
//             //     return ListTile(
//             //       title: Text(course.title!),
//             //     );
//             //   }).toList(),
//             // );
//             return Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 children: [
//                   LabelWidget(
//                     name: '',
//                     onSeeAllClicked: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute<void>(
//                           builder: (BuildContext context) =>
//                               CategoryCoursesPage(
//                             category: categories[index],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   CourseCardsListWidget(
//                     courses: courses,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
// //       body: FutureBuilder(
// //         future: FirebaseFirestore.instance.collection('categories').get(),
// //         builder: (ctx, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           if (snapshot.hasError) {
// //             return const Center(child: Text('Error occurred'));
// //           }

// //           if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
// //             return const Center(child: Text('No categories found'));
// //           }

// //           var categories = List<Category>.from(snapshot.data?.docs
// //                   .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
// //                   .toList() ??
// //               []);

// //           return Column(
// //             children: [
// //               DropdownButton<Category>(
// //                 hint: Text('Select a category'),
// //                 value: selectedCategory,
// //                 onChanged: (Category? newValue) {
// //                   setState(() {
// //                     selectedCategory = newValue;
// //                     if (newValue != null) {
// //                       futureCourses = FirebaseFirestore.instance
// //                           .collection('courses')
// //                           .where('categoryId',
// //                               isEqualTo:
// //                                   newValue.id) // Adjust based on your structure
// //                           .get()
// //                           .then((snapshot) => List<Course>.from(snapshot.docs
// //                               .map((e) =>
// //                                   Course.fromJson({'id': e.id, ...e.data()}))
// //                               .toList()));
// //                     } else {
// //                       futureCourses = null;
// //                     }
// //                   });
// //                 },
// //                 items: categories
// //                     .map<DropdownMenuItem<Category>>((Category category) {
// //                   return DropdownMenuItem<Category>(
// //                     value: category,
// //                     child: Text(category.name ??
// //                         'No Name'), // Adjust based on your Category model
// //                   );
// //                 }).toList(),
// //               ),
// //               if (futureCourses != null)
// //                 FutureBuilder<List<Course>>(
// //                   future: futureCourses,
// //                   builder: (ctx, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return const Center(child: CircularProgressIndicator());
// //                     }

// //                     if (snapshot.hasError) {
// //                       return const Center(child: Text('Error occurred'));
// //                     }

// //                     if (!snapshot.hasData ||
// //                         (snapshot.data?.isEmpty ?? false)) {
// //                       return const Center(child: Text('No courses found'));
// //                     }

// //                     var courses = snapshot.data!;

// //                     // return Expanded(
// //                     //   child: ListView.builder(
// //                     //     itemCount: courses.length,
// //                     //     itemBuilder: (context, index) {
// //                     //       return ListTile(
// //                     //         title: Text(courses[index]
// //                     //             .title!), // Adjust based on your Course model
// //                     //       );
// //                     //     },
// //                     //   ),
// //                     // );
// //                     return CourseCardsListWidget(courses: courses);
// //                   },
// //                 ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eduvista/models/category_item.dart';
// import 'package:eduvista/models/course.dart';
// import 'package:eduvista/pages/category_courses_page.dart';
// import 'package:eduvista/utils/color_utilis.dart';
// import 'package:eduvista/widgets/course/course_cards_List_widget.dart';
// import 'package:eduvista/widgets/home/label_widget.dart';
// import 'package:flutter/material.dart';

// class CategoriesExpandableListWidget extends StatefulWidget {
//   const CategoriesExpandableListWidget({
//     super.key,
//     required this.categories,
//     required this.category,
//     required this.index,
//   });

//   final List<CategoryItem> categories;
//   final CategoryItem category;
//   final int index;

//   @override
//   _CategoriesExpandableListWidgetState createState() =>
//       _CategoriesExpandableListWidgetState();
// }

// class _CategoriesExpandableListWidgetState
//     extends State<CategoriesExpandableListWidget> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         // border: _isExpanded ? Border.all(color: Colors.yellow) : null,
//         color: _isExpanded ? Colors.white : ColorUtility.grayLight,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: ExpansionTile(
//         // title: Container(
//         //   padding: EdgeInsets.all(10),
//         //   decoration: BoxDecoration(
//         //     border:
//         //         _isExpanded ? Border.all(color: ColorUtility.deepYellow) : null,
//         //     // color: _isExpanded ? Colors.white : ColorUtility.grayLight,
//         //     // borderRadius: BorderRadius.circular(8),
//         //   ),
//         title: Text(
//           widget.categories[widget.index].name ?? 'No Name',
//           style: TextStyle(
//               color: _isExpanded ? ColorUtility.deepYellow : Colors.black,
//               fontWeight: FontWeight.w600,
//               fontSize: 16),
//         ),
//         // ),
//         trailing: Icon(
//           color: _isExpanded ? ColorUtility.deepYellow : Colors.black,
//           _isExpanded
//               ? Icons.keyboard_double_arrow_down
//               : Icons.keyboard_double_arrow_right,
//         ),
//         collapsedIconColor: ColorUtility.deepYellow,
//         onExpansionChanged: (expanded) {
//           setState(() {
//             _isExpanded = expanded;
//           });
//         },
//         children: [
//           FutureBuilder(
//             future: FirebaseFirestore.instance
//                 .collection('courses')
//                 .where('category.id', isEqualTo: widget.category.id)
//                 .get(),
//             builder: (ctx, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (snapshot.hasError) {
//                 return const Center(child: Text('Error occurred'));
//               }

//               if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
//                 return const Center(child: Text('No courses found'));
//               }

//               var courses = List<Course>.from(snapshot.data?.docs
//                       .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
//                       .toList() ??
//                   []);
//               return Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     LabelWidget(
//                       name: '',
//                       onSeeAllClicked: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute<void>(
//                             builder: (BuildContext context) =>
//                                 CategoryCoursesPage(
//                               category: widget.categories[widget.index],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     CourseCardsListWidget(
//                       courses: courses,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvista/models/category_item.dart';
import 'package:eduvista/models/course.dart';
import 'package:eduvista/pages/category_courses_page.dart';
import 'package:eduvista/utils/color_utilis.dart';
import 'package:eduvista/widgets/course/course_cards_List_widget.dart';
import 'package:eduvista/widgets/home/label_widget.dart';
import 'package:flutter/material.dart';

class CategoriesExpandableListWidget extends StatefulWidget {
  const CategoriesExpandableListWidget({
    super.key,
    required this.categories,
    required this.category,
    required this.index,
  });

  final List<CategoryItem> categories;
  final CategoryItem category;
  final int index;

  @override
  _CategoriesExpandableListWidgetState createState() =>
      _CategoriesExpandableListWidgetState();
}

class _CategoriesExpandableListWidgetState
    extends State<CategoriesExpandableListWidget> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: _isExpanded ? Border.all(color: Colors.yellow) : null,
        color: _isExpanded ? Colors.white : ColorUtility.grayLight,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          _toggleExpansion();
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              // return Container(
              //   decoration: isExpanded
              //       ? BoxDecoration(
              //           border: Border.all(color: ColorUtility.deepYellow),
              //           borderRadius: BorderRadius.circular(8),
              //         )
              //       : null,
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: _isExpanded
                      ? Border.all(color: ColorUtility.deepYellow)
                      : null,
                  color: _isExpanded ? Colors.white : ColorUtility.grayLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.categories[widget.index].name ?? 'No Name',
                      style: TextStyle(
                        color:
                            isExpanded ? ColorUtility.deepYellow : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      color:
                          isExpanded ? ColorUtility.deepYellow : Colors.black,
                      isExpanded
                          ? Icons.keyboard_double_arrow_down
                          : Icons.keyboard_double_arrow_right,
                    ),
                  ],
                ),
              );
            },
            body: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('courses')
                  .where('category.id', isEqualTo: widget.category.id)
                  .get(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error occurred'));
                }

                if (!snapshot.hasData ||
                    (snapshot.data?.docs.isEmpty ?? false)) {
                  return const Center(child: Text('No courses found'));
                }

                var courses = List<Course>.from(snapshot.data?.docs
                        .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                        .toList() ??
                    []);
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelWidget(
                        name: '',
                        onSeeAllClicked: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  CategoryCoursesPage(
                                category: widget.categories[widget.index],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      CourseCardsListWidget(
                        courses: courses,
                      ),
                    ],
                  ),
                );
              },
            ),
            isExpanded: _isExpanded,
            canTapOnHeader: true,
          ),
        ],
      ),
    );
  }
}
