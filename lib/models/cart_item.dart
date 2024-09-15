import 'course.dart';

class CartItem {
  final Course course;
  int quantity;

  CartItem({required this.course, this.quantity = 1});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    Course course = Course.fromJson(json['course']);
    int quantity = json['quantity'] ?? 1;

    return CartItem(course: course, quantity: quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      'course': course.toJson(),
      'quantity': quantity,
    };
  }
}
