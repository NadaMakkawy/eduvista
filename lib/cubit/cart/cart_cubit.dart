import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import '../../models/cart_item.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]) {
    // loadCartItems();
  }

  String? currentCartId;

  void addToCart(Course course) async {
    final existingItem = state.firstWhere(
      (item) => item.course.id == course.id,
      orElse: () => CartItem(course: course, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      return;
    } else {
      if (currentCartId == null) {
        currentCartId = await _createNewCart();
      }

      await _saveCartItemToFirestore(CartItem(course: course, quantity: 1));
      state.add(CartItem(course: course, quantity: 1));
    }
    emit(List.from(state));
  }

  Future<String> _createNewCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final cartRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .add({'created_at': Timestamp.now()});

    return cartRef.id;
  }

  Future<void> _saveCartItemToFirestore(CartItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || currentCartId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .doc(currentCartId)
        .collection('items')
        // .add({
        .doc(item.course.id)
        .set({
      'course_id': item.course.id,
      'title': item.course.title,
      'price': item.course.price,
      'image': item.course.image,
      'instructor': item.course.instructor?.name,
      'added_at': Timestamp.now(),
    });
  }

  void removeFromCart(CartItem item) async {
    state.remove(item);
    emit(List.from(state));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || currentCartId == null) return;

    final itemQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .doc(currentCartId)
        .collection('items')
        .where('course_id', isEqualTo: item.course.id)
        .limit(1)
        .get();

    if (itemQuery.docs.isNotEmpty) {
      final documentId = itemQuery.docs.first.id;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('carts')
          .doc(currentCartId)
          .collection('items')
          .doc(documentId)
          .delete();
    }
  }

  void clearCart() async {
    state.clear();
    emit(List.from(state));

    currentCartId = await _createNewCart();
  }

  Future<void> purchaseCourses(
      BuildContext context, List<CartItem> cartItems) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    for (var item in cartItems) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchased_courses')
          .doc(item.course.id)
          .set({
        'course_id': item.course.id,
        'title': item.course.title,
        'price': item.course.price,
        'image': item.course.image,
        'instructor': item.course.instructor?.name,
        'purchased_at': Timestamp.now(),
      });
    }

    clearCart();
  }

  Future<void> loadCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    if (cartSnapshot.docs.isNotEmpty) {
      currentCartId = cartSnapshot.docs.first.id;

      final itemsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('carts')
          .doc(currentCartId)
          .collection('items')
          .get();

      if (itemsSnapshot.docs.isNotEmpty) {
        final items = itemsSnapshot.docs.map((doc) {
          final data = doc.data();
          return CartItem(
            course: Course.fromJson(data),
            quantity: data['quantity'] ?? 1,
          );
        }).toList();

        emit(items);
      } else {
        currentCartId = null;
      }
    }
  }

  Future<bool> isInCart(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || currentCartId == null) return false;

    final cartItemSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .doc(currentCartId)
        .collection('items')
        .doc(courseId)
        .get();

    return cartItemSnapshot.exists;
  }

  Future<bool> isCoursePurchased(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final purchasedCourseSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('purchased_courses')
        .doc(courseId)
        .get();

    return purchasedCourseSnapshot.exists;
  }
}
