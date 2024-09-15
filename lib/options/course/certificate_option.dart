import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/image_utility.dart';
import '../../utils/color_utilis.dart';

import '../../models/course.dart';

class CertificateOption extends StatefulWidget {
  final String title;

  CertificateOption({required this.title});

  @override
  State<CertificateOption> createState() => _CertificateOptionState();
}

class _CertificateOptionState extends State<CertificateOption> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;
  late Course? selectedCourse;
  final randomNumber = Random().nextInt(10000000) + 1;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance.collection('courses').get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

        var courses = List<Course>.from(snapshot.data?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        selectedCourse = courses.firstWhere(
          (course) => course.title == widget.title,
        );

        User? user = FirebaseAuth.instance.currentUser;

        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(0),
          content: Stack(
            children: [
              Positioned(
                left: 200,
                width: 180,
                top: -80,
                height: 190,
                child: Image.asset(
                  LogosImagesUtils.certificateCircle,
                  width: 180,
                  height: 180,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Certificate of Completion',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This Certifies that',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${user?.displayName?[0].toUpperCase()}${user?.displayName?.substring(1)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: ColorUtility.main,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Has Successfully Completed ${widget.title} Training Program.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Text(
                      selectedCourse != null
                          ? selectedCourse!.title ?? 'No Title'
                          : 'Course Not Found',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorUtility.deepBlue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Issued on ${selectedCourse?.created_date != null ? DateFormat('MMMM d, y').format(selectedCourse!.created_date!) : 'No Date'}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ID: #${randomNumber}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20),
                    Text(
                      ' ${selectedCourse!.instructor?.name ?? 'No Instructor'}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: ColorUtility.main,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      ' ${selectedCourse!.instructor?.name ?? 'No Instructor'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ColorUtility.deepBlue,
                      ),
                    ),
                    Text(
                      'Issued on ${selectedCourse?.created_date != null ? DateFormat('MMMM d, y').format(selectedCourse!.created_date!) : 'No Date'}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorUtility.gray),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 2,
                      width: 100,
                      color: ColorUtility.grayLight,
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 2,
                      width: 100,
                      color: ColorUtility.main,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showCertificate(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CertificateOption(
        title: title,
      );
    },
  );
}
