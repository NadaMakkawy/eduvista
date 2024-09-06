// import 'package:flutter/material.dart';

// import '../../utils/color_utilis.dart';

// class LecturesWidget extends StatefulWidget {
//   final String courseTitle;
//   const LecturesWidget({
//     required this.courseTitle,
//     super.key,
//   });

//   @override
//   State<LecturesWidget> createState() => _LecturesWidgetState();
// }

// class _LecturesWidgetState extends State<LecturesWidget> {
//   int _selectedIndex = -1;
//   String _selectedText = '';

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           color: Colors.black,
//           height: 200,
//           child: Center(
//             child: Text(
//               _selectedText,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//             child: Container(
//               color: Colors.white,
//               child: ListView(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.courseTitle,
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.w600),
//                         ),
//                         const Text(
//                           'Instructor name',
//                           style: TextStyle(
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 5,
//                       separatorBuilder: (context, index) => const SizedBox(
//                         width: 10,
//                       ),
//                       itemBuilder: (context, index) => Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: const Color(0xffE0E0E0),
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: Center(
//                           child: Text('Option ${index + 1}'),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   GridView.count(
//                     childAspectRatio: 1,
//                     mainAxisSpacing: 25,
//                     crossAxisSpacing: 25,
//                     shrinkWrap: true,
//                     crossAxisCount: 2,
//                     children: List.generate(6, (index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedIndex = index;
//                             _selectedText = 'Lecture ${index + 1}';
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: _selectedIndex == index
//                                 ? Colors.amber
//                                 : ColorUtility.grayExtraLight,
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Center(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Lecture ${index + 1}',
//                                       style: TextStyle(
//                                         color: _selectedIndex == index
//                                             ? Colors.white
//                                             : Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     Icon(
//                                       Icons.download,
//                                       color: _selectedIndex == index
//                                           ? Colors.white
//                                           : Colors.black,
//                                     )
//                                   ],
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       'Lecture title',
//                                       style: TextStyle(
//                                         color: _selectedIndex == index
//                                             ? Colors.white
//                                             : Colors.black,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       'Lecture description will be filled with lecture information',
//                                       style: TextStyle(
//                                         color: _selectedIndex == index
//                                             ? Colors.white
//                                             : Colors.black,
//                                         fontSize: 12,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 const Spacer(),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Duration of lecture ${index + 1}',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: _selectedIndex == index
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     Icon(
//                                       Icons.play_circle_outline,
//                                       size: 40,
//                                       color: _selectedIndex == index
//                                           ? Colors.white
//                                           : Colors.black,
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
