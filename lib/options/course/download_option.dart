import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/lecture.dart';

import '../../utils/color_utilis.dart';

import '../../widgets/course/lectures_widget.dart';

class DownloadOption extends StatefulWidget {
  final void Function(Lecture) onLectureChosen;
  Lecture? selectedLecture;

  DownloadOption(
      {required this.onLectureChosen,
      required this.selectedLecture,
      super.key});

  @override
  State<DownloadOption> createState() => _DownloadOptionState();
}

class _DownloadOptionState extends State<DownloadOption> {
  late Future<List<Lecture>> savedLecturesFuture;

  @override
  void initState() {
    super.initState();
    savedLecturesFuture = _getSavedLectures();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lecture>>(
      future: savedLecturesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading lectures'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No saved lectures'));
        }

        final lectures = snapshot.data!;

        return GridView.count(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(
            lectures.length,
            (index) {
              return InkWell(
                onTap: () async {
                  widget.onLectureChosen(lectures[index]);
                  widget.selectedLecture = lectures[index];

                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.selectedLecture?.id == lectures[index].id
                        ? ColorUtility.deepYellow
                        : const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: LecturesWidget(
                    selectedLecture: widget.selectedLecture,
                    lecture: lectures[index],
                    selectedIndex: index,
                    icon: Icons.check,
                    onIconPressed: () {},
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<List<Lecture>> _getSavedLectures() async {
    final prefs = await SharedPreferences.getInstance();
    List<Lecture> lectures = [];

    for (String key in prefs.getKeys()) {
      if (key.startsWith('savedLecture_')) {
        String? lectureJson = prefs.getString(key);
        if (lectureJson != null) {
          Map<String, dynamic> json = jsonDecode(lectureJson);
          lectures.add(Lecture.fromJson(json));
        }
      }
    }

    return lectures;
  }
}
