import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchasedCoursesPage extends StatelessWidget {
  static const String id = 'purchased_courses';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Purchased Courses')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('purchased_courses')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var courses = snapshot.data!.docs;

          if (courses.isEmpty) {
            return Center(child: Text('No purchased courses.'));
          }

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var courseData = courses[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(courseData['title']),
                subtitle: Text('\$${courseData['price']}'),
              );
            },
          );
        },
      ),
    );
  }
}
