import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/color_utilis.dart';

import '../pages/top_courses_page.dart';
import '../pages/pending_cart_page.dart';
import '../pages/all_categories_page.dart';
import '../pages/clicked_courses_page.dart';

import '../widgets/home/label_widget.dart';
import '../widgets/course/courses_widget.dart';
import '../widgets/home/categories_widget.dart';
import '../widgets/course/clicked_courses_widget.dart';

class HomePage extends StatefulWidget {
  static const String id = 'Home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeMessage = 'Loading...';
  List<String> _clickedCourses = [];
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _checkUserStatus();
    _fetchClickedCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => PendingCartPage(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart))
        ],
        title: FittedBox(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: welcomeMessage.split(',')[0] + ', ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                TextSpan(
                  text:
                      '${user?.displayName?[0].toUpperCase()}${user?.displayName?.substring(1)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorUtility.main,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
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
                if (_clickedCourses.isNotEmpty) ...[
                  LabelWidget(
                    name: 'Because you Viewed',
                    onSeeAllClicked: () {
                      Navigator.pushNamed(context, ClickedCoursesPage.id,
                          arguments: _clickedCourses);
                    },
                  ),
                  ClickedCoursesWidget(clickedCourseIds: _clickedCourses),
                ],
                LabelWidget(
                  name: 'Students also search for',
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
                CoursesWidget(
                  rankValue: null,
                ),
                LabelWidget(
                  name: 'Top Courses in UI/UX',
                  onSeeAllClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => TopCoursesPage(
                          rankValue: 'Top Rated UI/UX',
                        ),
                      ),
                    );
                  },
                ),
                CoursesWidget(
                  rankValue: 'Top Rated UI/UX',
                ),
                LabelWidget(
                  name: 'Top Sellers',
                  onSeeAllClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => TopCoursesPage(
                          rankValue: 'Top Sellers',
                        ),
                      ),
                    );
                  },
                ),
                CoursesWidget(
                  rankValue: 'Top Sellers',
                ),
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
      setState(() {
        welcomeMessage = isNew ? 'Welcome' : 'Welcome back';
      });
    }
  }

  Future<void> _fetchClickedCourses() async {
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final clickedCoursesSnapshot = await firestore
        .collection('users')
        .doc(user!.uid)
        .collection('clicked_courses')
        .get();

    setState(() {
      _clickedCourses =
          clickedCoursesSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<bool> isClicked(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final clickedCourseSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('clicked_courses')
        .doc(courseId)
        .get();

    return clickedCourseSnapshot.exists;
  }
}
