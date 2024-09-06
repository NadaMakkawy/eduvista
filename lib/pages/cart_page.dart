import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart/cart_cubit.dart';

import '../models/cart_item.dart';

class CartPage extends StatelessWidget {
  static const String id = 'cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }

          double total = cartItems.fold(
              0, (sum, item) => sum + item.course.price! * item.quantity);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cartItems[index].course.title!),
                      subtitle: Text(
                          '\$${cartItems[index].course.price} x ${cartItems[index].quantity}'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          context
                              .read<CartCubit>()
                              .removeFromCart(cartItems[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
              Text('Total: \$${total.toString()}'),
              ElevatedButton(
                onPressed: () async {
                  await handlePurchase(cartItems, context);

                  context.read<CartCubit>().clearCart();
                },
                child: Text('Purchase'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> handlePurchase(
      List<CartItem> cartItems, BuildContext context) async {
    await context.read<CartCubit>().purchaseCourses(context, cartItems);
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/cart/cart_cubit.dart';
// import '../models/cart_item.dart';
// import '../models/course.dart';

// class CartPage extends StatelessWidget {
//   static const String id = 'cart';

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(title: Text('Cart')),
//       // body: BlocBuilder<CartCubit, List<CartItem>>(
//       //   builder: (context, cartItems) {
//       //     if (cartItems.isEmpty) {
//       //       return Center(child: Text('Your cart is empty.'));
//       //     }

//       //     double total = cartItems.fold(
//       //         0, (sum, item) => sum + item.course.price! * item.quantity);

//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .collection('purchased_courses')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           var cartItems = snapshot.data!.docs;
//           if (cartItems.isEmpty) {
//             return Center(child: Text('Your cart is empty.'));
//           }

//           // double total = cartItems.fold(
//           //     0, (sum, item) => sum + item.course.price! * item.quantity);
//           // Calculate total
//           // double total = cartItems.fold(0, (sum, item) {
//           //   var courseData = item.data() as Map<String, dynamic>;
//           //   double price = courseData['price'] is int
//           //       ? (courseData['price'] as int).toDouble()
//           //       : courseData['price'];
//           //   int quantity = courseData['quantity'] ?? 1;
//           //   return sum + (price * quantity);
//           // });
//           // Convert to CartItem list
//
//           List<CartItem> cartItemList = cartItems.map((doc) {
//             var courseData = doc.data() as Map<String, dynamic>;
//             return CartItem(
//               course: Course.fromJson(
//                   courseData), // Ensure Course is properly instantiated
//               quantity: courseData['quantity'] ?? 1,
//             );
//           }).toList();

//           // Calculate total
//           double total = cartItemList.fold(0, (sum, item) {
//             return sum + (item.course.price! * item.quantity);
//           });

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: cartItems.length,
//                   itemBuilder: (context, index) {
//                     var courseData =
//                         cartItems[index].data() as Map<String, dynamic>;
//                     return ListTile(
//                       title: Text(courseData['title']),
//                       subtitle: Text(
//                           '\$${courseData['price']} x ${courseData['quantity']}'),
//                       trailing: IconButton(
//                         icon: Icon(Icons.remove),
//                         onPressed: () {
//                           context
//                               .read<CartCubit>()
//                               .removeFromCart(courseData[index]);
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Text('Total: \$${total.toString()}'),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Handle purchase logic
//                   // Link this purchase to the user in Firestore
//                   // await purchaseCourses(context, cartItems);
//                   await handlePurchase(cartItemList, context);

//                   context
//                       .read<CartCubit>()
//                       .clearCart(); // Clear cart after purchase
//                 },
//                 child: Text('Purchase'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }


//   Future<void> handlePurchase(
//       List<CartItem> cartItems, BuildContext context) async {
//     await context.read<CartCubit>().purchaseCourses(context, cartItems);
//   }


// }
