import 'package:cloud_firestore/cloud_firestore.dart';

import 'instructor.dart';
import 'category_item.dart';

class Course {
  String? id;
  String? title;
  String? image;
  CategoryItem? category;
  String? currency;
  String? rank;
  bool? has_certificate;
  Instructor? instructor;
  double? price;
  double? rating;
  int? total_hours;
  DateTime? created_date;

  Course.fromJson(Map<String, dynamic> data) {
    id = data['id'] as String?;
    title = data['title'] as String?;
    image = data['image'] as String?;
    category = data['category'] != null
        ? CategoryItem.fromJson(data['category'] as Map<String, dynamic>)
        : null;
    currency = data['currency'] as String?;
    rank = data['rank'] as String?;
    has_certificate = data['has_certificate'] as bool?;

    if (data['instructor'] is Map<String, dynamic>) {
      instructor = Instructor.fromJson(data['instructor']);
    } else if (data['instructor'] is String) {
      instructor = Instructor(name: data['instructor']);
    } else {
      instructor = null;
    }

    price = data['price'] is int
        ? (data['price'] as int).toDouble()
        : data['price'] as double?;
    rating = data['rating'] is int
        ? (data['rating'] as int).toDouble()
        : data['rating'] as double?;

    total_hours = data['total_hours'] as int?;
    created_date = data['created_date'] != null
        ? (data['created_date'] as Timestamp).toDate()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['category'] = category?.toJson();
    data['currency'] = currency;
    data['rank'] = rank;
    data['has_certificate'] = has_certificate;
    data['instructor'] = instructor?.toJson();
    data['price'] = price;
    data['rating'] = rating;
    data['total_hours'] = total_hours;

    return data;
  }
}
