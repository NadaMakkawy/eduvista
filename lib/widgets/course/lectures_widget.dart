import 'package:flutter/material.dart';

import '../../models/lecture.dart';

class LecturesWidget extends StatefulWidget {
  final Lecture? lecture;
  final Lecture? selectedLecture;
  final int selectedIndex;
  final IconData? icon;
  final Function()? onIconPressed;

  const LecturesWidget({
    required this.selectedLecture,
    required this.lecture,
    required this.selectedIndex,
    required this.icon,
    required this.onIconPressed,
    super.key,
  });

  @override
  State<LecturesWidget> createState() => _LecturesWidgetState();
}

class _LecturesWidgetState extends State<LecturesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Lecture ${widget.selectedIndex + 1}',
                style: TextStyle(
                  color: widget.selectedLecture?.id == widget.lecture!.id
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: widget.onIconPressed,
                  icon: Icon(
                    widget.icon,
                    color: widget.selectedLecture?.id == widget.lecture!.id
                        ? Colors.white
                        : Colors.black,
                  ))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.lecture!.title ?? 'No Title',
                style: TextStyle(
                  color: widget.selectedLecture?.id == widget.lecture!.id
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.lecture!.description ?? 'No Describtion',
                style: TextStyle(
                  color: widget.selectedLecture?.id == widget.lecture!.id
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12,
                ),
              )
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'Duration of lecture \n${(widget.lecture!.duration! / 60).round()} min',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.selectedLecture?.id == widget.lecture!.id
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.play_circle_outline,
                size: 40,
                color: widget.selectedLecture?.id == widget.lecture!.id
                    ? Colors.white
                    : Colors.black,
              )
            ],
          ),
        ],
      ),
    );
  }
}
