import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../cubit/auth/auth_cubit.dart';

import '../models/course.dart';
import '../models/category_item.dart';

import '../pages/cart_page.dart';
import '../pages/top_courses_page.dart';
import '../pages/all_categories_page.dart';
import '../pages/purchased_courses_page.dart';

import '../widgets/home/label_widget.dart';
import '../widgets/course/courses_widget.dart';
import '../widgets/home/categories_widget.dart';
import '../widgets/course/clicked_courses_widget.dart';
import '../widgets/account_info/image_uploader_circle.dart';

class HomePage extends StatefulWidget {
  static const String id = 'Home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeMessage = 'Loading...';
  final List<Course> _clickedCourses = [];
  List<CategoryItem>? categories;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _checkUserStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout(context: context);
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => CartPage(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart))
        ],
        title: FittedBox(
          child: Row(
            children: [
              ImageUploaderCircle(),
              SizedBox(width: 10),
              Text(
                welcomeMessage,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                LabelWidget(
                  name: 'Categories',
                  onSeeAllClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AllCategorisPage(),
                      ),
                    );
                  },
                ),
                CategoriesWidget(),
                const SizedBox(
                  height: 20,
                ),
                LabelWidget(
                  name: 'Top Rated Courses',
                  onSeeAllClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => TopCoursesPage(
                          rankValue: 'top rated',
                        ),
                      ),
                    );
                  },
                ),
                CoursesWidget(
                  rankValue: 'top rated',
                ),
                LabelWidget(
                  name: 'Top Seller Courses',
                  onSeeAllClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => TopCoursesPage(
                          rankValue: 'top seller',
                        ),
                      ),
                    );
                  },
                ),
                CoursesWidget(
                  rankValue: 'top seller',
                ),
                if (_clickedCourses.isNotEmpty) ...[
                  LabelWidget(
                    name: 'Interested Courses',
                    onSeeAllClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => TopCoursesPage(
                            rankValue: null,
                          ),
                        ),
                      );
                    },
                  ),
                  ClickedCoursesWidget(
                    clickedCourses: _clickedCourses,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(user.uid);

    final userData = await userDoc.get();
    if (userData.exists) {
      final isNew = userData.data()?['isNew'] ?? false;
      if (isNew) {
        setState(() {
          welcomeMessage = 'Welcome, ${user.displayName}';
        });
      } else {
        setState(() {
          welcomeMessage = 'Welcome back, ${user.displayName}';
        });
      }
    }
  }
}
