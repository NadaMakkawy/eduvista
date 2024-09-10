import 'package:eduvista/utils/color_utilis.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '4.5',
                      style: TextStyle(fontSize: 14, color: ColorUtility.gray),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star_half, color: Colors.amber, size: 16),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'UI/UX Design',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_outlined,
                      color: ColorUtility.gray,
                    ),
                    Text(
                      'Stephen Moris',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$14.50',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorUtility.main,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
