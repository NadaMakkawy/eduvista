// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../cubit/cart/cart_cubit.dart';

// import '../models/course.dart';
// import '../models/category.dart';

// class CoursesPage extends StatelessWidget {
//   final Category category;

//   const CoursesPage({Key? key, required this.category}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Courses in ${category.name}')),
//       body: FutureBuilder(
//         future: FirebaseFirestore.instance
//             .collection('courses')
//             .where('category.id', isEqualTo: category.id)
//             .get(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text('Error occurred'));
//           }

//           if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
//             return const Center(child: Text('No courses found'));
//           }

//           var courses = List<Course>.from(snapshot.data?.docs
//                   .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
//                   .toList() ??
//               []);

//           return SizedBox(
//             height: 250.h,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 // bool isInCart =
//                 //     context.read<CartCubit>().isInCart(courses[index]);
//                 return InkWell(
//                   onTap: () async {
//                     // Update Firestore
//                     await FirebaseFirestore.instance
//                         .collection('courses')
//                         .doc(courses[index].id)
//                         .update({'is_clicked': true});

//                     // Set the is_clicked property in the app state
//                     courses[index].is_clicked = true;

//                     // Trigger the course click callback
//                     // Navigator.pushNamed(context, CourseDetailsPage.id,
//                     //     arguments: courses[index]);
//                   },
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 100.h,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(40),
//                           child: Image.network(
//                             courses[index].image ?? 'No Image',
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(courses[index].instructor?.name ?? 'No Instructor'),
//                       const SizedBox(height: 10),
//                       Text(courses[index].title ?? 'No Title'),
//                       const SizedBox(height: 10),
//                       Text('\$${courses[index].price?.toStringAsFixed(2)}'),
//                       // const SizedBox(height: 10),
//                       // Text(
//                       //     'Duration: ${courses[index].total_hours ?? '0'} hours'),
//                       // const SizedBox(height: 10),

//                       ElevatedButton(
//                         onPressed: () {
//                           context.read<CartCubit>().addToCart(courses[index]);
//                         },
//                         child: const Text('Add to Cart'),
//                       )
//                     ],
//                   ),
//                 );
//               },
//               itemCount: courses.length,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Future<void> pendingCourses(
//   //     BuildContext context, List<CartItem> cartItems) async {
//   //   // Get current user
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   if (user == null) return;

//   //   // Save purchased courses to user's document
//   //   for (var item in cartItems) {
//   //     await FirebaseFirestore.instance
//   //         .collection('users')
//   //         .doc(user.uid)
//   //         .collection('cart')
//   //         .add({
//   //       'course_id': item.course.id,
//   //       'title': item.course.title,
//   //       'price': item.course.price,
//   //       'added_at': Timestamp.now(),
//   //     });
//   //   }
//   // }
//   // Future<void> savePendingCourses(
//   //     List<CartItem> cartItems, BuildContext context) async {
//   //   await context.read<CartCubit>().pendingCourses(context, cartItems);
//   // }
//   // Future<void> pendingCourses(
//   //     BuildContext context, List<CartItem> cartItems) async {
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   if (user == null) return;

//   //   // Clear existing cart items for the user (optional)
//   //   final cartRef = FirebaseFirestore.instance
//   //       .collection('users')
//   //       .doc(user.uid)
//   //       .collection('cart');
//   //   final existingCartItems = await cartRef.get();
//   //   for (var doc in existingCartItems.docs) {
//   //     await doc.reference.delete();
//   //   }

//   //   // Save purchased courses to user's document
//   //   for (var item in cartItems) {
//   //     await cartRef.add({
//   //       'course_id': item.course.id,
//   //       'title': item.course.title,
//   //       'price': item.course.price,
//   //       'added_at': Timestamp.now(),
//   //     });
//   //   }
//   // }
// }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // import '../cubit/cart/cart_cubit.dart';
// // import '../models/course.dart';
// // import '../models/category.dart';

// // class CoursesPage extends StatelessWidget {
// //   final Category category;

// //   const CoursesPage({Key? key, required this.category}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final userId = FirebaseAuth.instance.currentUser?.uid;

// //     return Scaffold(
// //       appBar: AppBar(title: Text('Courses in ${category.name}')),
// //       body: FutureBuilder(
// //         future: FirebaseFirestore.instance
// //             .collection('courses')
// //             .where('category.id', isEqualTo: category.id)
// //             .get(),
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

// //           return FutureBuilder<List<String>>(
// //             future: userId != null
// //                 ? context.read<CartCubit>().getPurchasedCourses()
// //                 : Future.value([]),
// //             builder: (context, purchasedSnapshot) {
// //               if (purchasedSnapshot.connectionState ==
// //                   ConnectionState.waiting) {
// //                 return const Center(child: CircularProgressIndicator());
// //               }

// //               if (purchasedSnapshot.hasError) {
// //                 return const Center(
// //                     child: Text('Error loading purchased courses'));
// //               }

// //               final purchasedCourseIds = purchasedSnapshot.data ?? [];

// //               return SizedBox(
// //                 height: 250.h,
// //                 child: ListView.builder(
// //                   scrollDirection: Axis.horizontal,
// //                   itemCount: courses.length,
// //                   itemBuilder: (context, index) {
// //                     final course = courses[index];
// //                     final isPurchased = purchasedCourseIds.contains(course.id);

// //                     return InkWell(
// //                       onTap: () async {
// //                         await FirebaseFirestore.instance
// //                             .collection('courses')
// //                             .doc(course.id)
// //                             .update({'is_clicked': true});
// //                         course.is_clicked = true;
// //                       },
// //                       child: Column(
// //                         children: [
// //                           SizedBox(
// //                             height: 100.h,
// //                             child: ClipRRect(
// //                               borderRadius: BorderRadius.circular(40),
// //                               child: Image.network(
// //                                 course.image ?? 'No Image',
// //                                 fit: BoxFit.fill,
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 20),
// //                           Text(course.instructor?.name ?? 'No Instructor'),
// //                           const SizedBox(height: 10),
// //                           Text(course.title ?? 'No Title'),
// //                           const SizedBox(height: 10),
// //                           Text('\$${course.price?.toStringAsFixed(2)}'),
// //                           const SizedBox(height: 10),
// //                           if (!isPurchased)
// //                             ElevatedButton(
// //                               onPressed: () {
// //                                 context.read<CartCubit>().addToCart(course);
// //                               },
// //                               child: const Text('Add to Cart'),
// //                             ),
// //                         ],
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/course.dart';
import '../models/category.dart';
import '../widgets/course/course_cards_List_widget.dart';

class CoursesPage extends StatelessWidget {
  final Category category;
  final Function(Course) onCourseClick;

  const CoursesPage(
      {Key? key, required this.category, required this.onCourseClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Courses in ${category.name}')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('courses')
            .where('category.id', isEqualTo: category.id)
            .get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          }

          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return const Center(child: Text('No courses found'));
          }

          var courses = List<Course>.from(snapshot.data?.docs
                  .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          // return SizedBox(
          //   height: 250.h,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       final course = courses[index];

          //       return FutureBuilder<bool>(
          //         future:
          //             context.read<CartCubit>().isCoursePurchased(course.id!),
          //         builder: (context, purchaseSnapshot) {
          //           if (purchaseSnapshot.connectionState ==
          //               ConnectionState.waiting) {
          //             return const Center(child: CircularProgressIndicator());
          //           }

          //           // If there was an error checking purchase status
          //           if (purchaseSnapshot.hasError) {
          //             return const Center(child: Text('Error occurred'));
          //           }

          //           final isPurchased = purchaseSnapshot.data ?? false;

          //           return InkWell(
          //             onTap: () async {
          //               await FirebaseFirestore.instance
          //                   .collection('courses')
          //                   .doc(course.id)
          //                   .update({'is_clicked': true});

          //               course.is_clicked = true;

          //               // Trigger the course click callback
          //               // Navigator.pushNamed(context, CourseDetailsPage.id,
          //               //     arguments: course);
          //             },
          //             child: Column(
          //               children: [
          //                 SizedBox(
          //                   height: 100.h,
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(40),
          //                     child: Image.network(
          //                       course.image ?? 'No Image',
          //                       fit: BoxFit.fill,
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(height: 20),
          //                 Text(course.instructor?.name ?? 'No Instructor'),
          //                 const SizedBox(height: 10),
          //                 Text(course.title ?? 'No Title'),
          //                 const SizedBox(height: 10),
          //                 Text('\$${course.price?.toStringAsFixed(2)}'),

          //                 // Show the Add to Cart button only if the course is not purchased
          //                 if (!isPurchased)
          //                   ElevatedButton(
          //                     onPressed: () {
          //                       context.read<CartCubit>().addToCart(course);
          //                     },
          //                     child: const Text('Add to Cart'),
          //                   )
          //                 else
          //                   const Text('Purchased',
          //                       style: TextStyle(color: Colors.green)),
          //               ],
          //             ),
          //           );
          //         },
          //       );
          //     },
          //     itemCount: courses.length,
          //   ),
          // );
          return CourseCardsListWidget(
            courses: courses,
          );
        },
      ),
    );
  }
}
