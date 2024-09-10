import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import '../../models/cart_item.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]) {
    _loadCartItems();
  }

  String? currentCartId; // To track the current cart's ID

  void addToCart(Course course) async {
    final existingItem = state.firstWhere(
      (item) => item.course.id == course.id,
      orElse: () => CartItem(course: course, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      // Item already in cart, do not increase the quantity
      // existingItem.quantity;
      return;
    } else {
      // Create a new cart document if it doesn't exist
      if (currentCartId == null) {
        currentCartId = await _createNewCart();
      }

      await _saveCartItemToFirestore(CartItem(course: course, quantity: 1));
      state.add(CartItem(course: course, quantity: 1));
    }
    emit(List.from(state)); // Emit the new state
  }

  Future<String> _createNewCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    // Create a new cart document and return its ID
    final cartRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .add({'created_at': Timestamp.now()});

    return cartRef.id; // Return the new cart ID
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
        .doc(item.course.id) // Use course ID as document ID
        .set({
      'course_id': item.course.id,
      'title': item.course.title,
      'price': item.course.price,
      'added_at': Timestamp.now(),
    });
  }

  void removeFromCart(CartItem item) async {
    // Remove the item from the state
    state.remove(item);
    emit(List.from(state)); // Emit the new state

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || currentCartId == null) return;

    // Find the document for this item in Firestore
    final itemQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .doc(currentCartId)
        .collection('items')
        .where('course_id', isEqualTo: item.course.id)
        .limit(1) // Get only one document
        .get();

    // Check if the item exists in Firestore
    if (itemQuery.docs.isNotEmpty) {
      // Remove the item from Firestore using its document ID
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
    state.clear(); // Clear the cart items
    emit(List.from(state)); // Emit the new state

    // create a new cart ID for future items
    currentCartId = await _createNewCart(); // Prepare for a new cart
  }

  // Future<void> purchaseCourses(
  //     BuildContext context, List<CartItem> cartItems) async {
  //   // Get current user
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;

  //   // Save purchased courses to user's document
  //   for (var item in cartItems) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('purchased_courses')
  //         .add({
  //       'course_id': item.course.id,
  //       'title': item.course.title,
  //       'price': item.course.price,
  //       'purchased_at': Timestamp.now(),
  //     });
  //   }
  //   // Clear the cart after purchase
  //   clearCart();
  // }

  Future<void> purchaseCourses(
      BuildContext context, List<CartItem> cartItems) async {
    // Get current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Save purchased courses to user's document
    for (var item in cartItems) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchased_courses')
          .doc(item.course.id) // Use course ID as document ID
          .set({
        'course_id': item.course.id,
        'title': item.course.title,
        'price': item.course.price,
        'purchased_at': Timestamp.now(),
      });
    }

    // Clear the cart after purchase
    clearCart();
  }

  Future<void> _loadCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Fetch the most recent cart
    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    if (cartSnapshot.docs.isNotEmpty) {
      currentCartId = cartSnapshot.docs.first.id;

      // Check if the cart is empty
      final itemsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('carts')
          .doc(currentCartId)
          .collection('items')
          .get();

      // Only load items if the cart is not empty
      if (itemsSnapshot.docs.isNotEmpty) {
        final items = itemsSnapshot.docs.map((doc) {
          final data = doc.data();
          return CartItem(
            course: Course.fromJson(data),
            quantity: data['quantity'] ?? 1,
          );
        }).toList();

        emit(items); // Emit the loaded items
      } else {
        // clear the currentCartId if the cart is empty
        currentCartId = null;
      }
    }
  }

  // bool isInCart(Course course) {
  //   return state.any((item) => item.course.id == course.id);
  // }

  // Future<bool> isInCart(String courseId) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return false;

  //   // Check if the course is in the purchased_courses collection
  //   final purchasedCourseSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('carts')
  //       .doc(courseId) // Check for the specific course ID
  //       .get();

  //   // Return true if the document exists, false otherwise
  //   return purchasedCourseSnapshot.exists;
  // }

  Future<bool> isInCart(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || currentCartId == null) return false;

    // Check if the course is in the items subcollection of the current cart
    final cartItemSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .doc(currentCartId)
        .collection('items')
        .doc(
            courseId) // Check for the specific course ID in the items collection
        .get();

    // Return true if the document exists, false otherwise
    return cartItemSnapshot.exists;
  }

  Future<bool> isCoursePurchased(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    // Check if the course is in the purchased_courses collection
    final purchasedCourseSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('purchased_courses')
        .doc(courseId) // Check for the specific course ID
        .get();

    // Return true if the document exists, false otherwise
    return purchasedCourseSnapshot.exists;
  }
}
