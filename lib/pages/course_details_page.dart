import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/course/course_bloc.dart';
import '../bloc/lecture/lecture_bloc.dart';

import '../models/course.dart';

import '../utils/color_utilis.dart';

import '../widgets/course/lecture_chips.dart';
import '../widgets/course/video_box_widget.dart';
import '../widgets/course/course_options_widgets.dart';

class CourseDetailsPage extends StatefulWidget {
  static const String id = 'CourseDetailsPage';
  final Course course;
  const CourseDetailsPage({required this.course, super.key});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  double? height;

  @override
  void initState() {
    context.read<CourseBloc>().add(CourseFetchEvent(widget.course));
    context.read<LectureBloc>().add(LectureEventInitial());
    super.initState();
  }

  bool applyChanges = false;

  void initAnimation() async {
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {
        applyChanges = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    initAnimation();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BlocBuilder<LectureBloc, LectureState>(builder: (ctx, state) {
          var stateEx = state is LectureChosenState ? state : null;

          if (stateEx == null) {
            return const SizedBox.shrink();
          }

          return SizedBox(
            height: 250,
            child: stateEx.lecture.lecture_url == null ||
                    stateEx.lecture.lecture_url == ''
                ? const Center(
                    child: Text(
                    'Invalid Url',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ))
                : VideoBoxWidget(
                    url: stateEx.lecture.lecture_url ?? '',
                  ),
          );
        }),
        Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              duration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
              height:
                  applyChanges ? MediaQuery.sizeOf(context).height - 220 : null,
              curve: Curves.easeInOut,
              child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.course.title ?? 'No Title',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.course.instructor?.name ??
                              'No Instructor Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const _BodyWidget()
                      ],
                    )),
              ),
            )),
        Positioned(
          top: 20,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: ColorUtility.main,
            ),
          ),
        ),
      ],
    ));
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget();

  @override
  State<_BodyWidget> createState() => __BodyWidgetState();
}

class __BodyWidgetState extends State<_BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (ctx, state) {
          return Column(
            children: [
              LectureChipsWidget(
                selectedOption: (state is CourseOptionStateChanges)
                    ? state.courseOption
                    : null,
                onChanged: (courseOption) {
                  context
                      .read<CourseBloc>()
                      .add(CourseOptionChosenEvent(courseOption));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: (state is CourseOptionStateChanges)
                      ? CourseOptionsWidgets(
                          course: context.read<CourseBloc>().course!,
                          courseOption: state.courseOption,
                          onLectureChosen: (lecture) {
                            try {
                              FirebaseFirestore.instance
                                  .collection('course_user_progress')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                context.read<CourseBloc>().course!.id!:
                                    FieldValue.increment(1)
                              });
                            } catch (e) {
                              FirebaseFirestore.instance
                                  .collection('course_user_progress')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .set({
                                context.read<CourseBloc>().course!.id!: 1
                              });
                            }
                            context
                                .read<LectureBloc>()
                                .add(LectureChosenEvent(lecture));
                          },
                        )
                      : const SizedBox.shrink())
            ],
          );
        },
      ),
    );
  }
}
