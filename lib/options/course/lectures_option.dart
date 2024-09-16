import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/cart/cart_cubit.dart';
import '../../models/course.dart';
import '../../widgets/course/lectures_widget.dart';

import '../../models/lecture.dart';

import '../../utils/color_utilis.dart';

class LecturesOption extends StatefulWidget {
  final Course course;
  final List<Lecture>? lectures;
  final void Function(Lecture) onLectureChosen;
  Lecture? selectedLecture;

  LecturesOption(
      {required this.lectures,
      required this.onLectureChosen,
      required this.selectedLecture,
      required this.course,
      super.key});

  @override
  State<LecturesOption> createState() => _LecturesOptionState();
}

class _LecturesOptionState extends State<LecturesOption> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(
        widget.lectures!.length,
        (index) {
          // return InkWell(
          //   onTap: () async {
          //     widget.onLectureChosen(widget.lectures![index]);
          //     widget.selectedLecture = widget.lectures![index];

          //     setState(() {});
          //   },
          return InkWell(
            onTap: () async {
              final isPurchased = await context
                  .read<CartCubit>()
                  .isCoursePurchased(widget.course.id!);

              // if (!isPurchased) {
              //   _showPurchaseAlert();
              //   return;
              // }

              // widget.onLectureChosen(widget.lectures![index]);
              // widget.selectedLecture = widget.lectures![index];

              // setState(() {});
              if (index == 0 || isPurchased) {
                widget.onLectureChosen(widget.lectures![index]);
                widget.selectedLecture = widget.lectures![index];
                setState(() {});
              } else {
                _showPurchaseAlert();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.selectedLecture?.id == widget.lectures![index].id
                    ? ColorUtility.deepYellow
                    : const Color(0xffE0E0E0),
                borderRadius: BorderRadius.circular(25),
              ),
              child: LecturesWidget(
                selectedLecture: widget.selectedLecture,
                lecture: widget.lectures![index],
                selectedIndex: index,
                icon: Icons.download,
                onIconPressed: () async {
                  await _saveLectureToPreferences(widget.lectures![index]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lecture saved!')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveLectureToPreferences(Lecture lecture) async {
    final prefs = await SharedPreferences.getInstance();
    String lectureJson = jsonEncode(lecture.toJson());
    await prefs.setString('savedLecture_${lecture.id}', lectureJson);
  }

  void _showPurchaseAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Purchase Required'),
          content:
              Text('You need to purchase the course to access this lecture.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
