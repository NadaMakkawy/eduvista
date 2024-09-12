import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import '../../models/category_item.dart';

import '../../pages/category_courses_page.dart';

import '../../utils/color_utilis.dart';

import '../../widgets/home/label_widget.dart';
import '../../widgets/course/course_cards_List_widget.dart';

class CategoriesExpandableListWidget extends StatefulWidget {
  const CategoriesExpandableListWidget({
    super.key,
    required this.categories,
    required this.category,
    required this.index,
  });

  final List<CategoryItem> categories;
  final CategoryItem category;
  final int index;

  @override
  _CategoriesExpandableListWidgetState createState() =>
      _CategoriesExpandableListWidgetState();
}

class _CategoriesExpandableListWidgetState
    extends State<CategoriesExpandableListWidget> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isExpanded ? Colors.white : ColorUtility.grayLight,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          _toggleExpansion();
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: _isExpanded
                      ? Border.all(color: ColorUtility.deepYellow)
                      : null,
                  color: _isExpanded ? Colors.white : ColorUtility.grayLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.categories[widget.index].name ?? 'No Name',
                      style: TextStyle(
                        color:
                            isExpanded ? ColorUtility.deepYellow : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      color:
                          isExpanded ? ColorUtility.deepYellow : Colors.black,
                      isExpanded
                          ? Icons.keyboard_double_arrow_down
                          : Icons.keyboard_double_arrow_right,
                    ),
                  ],
                ),
              );
            },
            body: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('courses')
                  .where('category.id', isEqualTo: widget.category.id)
                  .get(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error occurred'));
                }

                if (!snapshot.hasData ||
                    (snapshot.data?.docs.isEmpty ?? false)) {
                  return const Center(child: Text('No courses found'));
                }

                var courses = List<Course>.from(snapshot.data?.docs
                        .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                        .toList() ??
                    []);
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelWidget(
                        name: '',
                        onSeeAllClicked: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  CategoryCoursesPage(
                                category: widget.categories[widget.index],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      CourseCardsListWidget(
                        courses: courses,
                      ),
                    ],
                  ),
                );
              },
            ),
            isExpanded: _isExpanded,
            canTapOnHeader: true,
          ),
        ],
      ),
    );
  }
}
