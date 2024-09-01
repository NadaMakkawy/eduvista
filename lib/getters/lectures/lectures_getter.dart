import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';

Course? course;

var lecturesGetter = FirebaseFirestore.instance
    .collection('courses')
    .doc(course!.id)
    .collection('lectures')
    .get();
