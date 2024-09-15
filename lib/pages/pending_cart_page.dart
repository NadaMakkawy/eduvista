import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart/cart_cubit.dart';

import '../models/cart_item.dart';

import '../utils/color_utilis.dart';

import '../widgets/course/course_tile_widget.dart';

import '../pages/cart_page.dart';
import '../pages/course_details_page.dart';

class PendingCartPage extends StatefulWidget {
  static const String id = 'PendingCartPage';

  @override
  State<PendingCartPage> createState() => _PendingCartPageState();
}

class _PendingCartPageState extends State<PendingCartPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ColorUtility.main,
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }

          double total = cartItems.fold(
              0, (sum, item) => sum + item.course.price! * item.quantity);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var course = cartItems[index].course;

                    return ExpansionTile(
                      title: InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, CourseDetailsPage.id,
                            arguments: course),
                        child: FittedBox(
                          child: Column(
                            children: [
                              CourseTileWidget(
                                course: course,
                                showExtraInfo: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_drop_down,
                        color: _isExpanded
                            ? ColorUtility.deepYellow
                            : ColorUtility.main,
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isExpanded = expanded;
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<CartCubit>()
                                      .removeFromCart(cartItems[index]);
                                },
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUtility.grayExtraLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<CartCubit>().addToCart(course);
                                },
                                child: Text(
                                  'Buy Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUtility.deepYellow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Total: \$${total.toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorUtility.main,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartCubit>().clearCart();
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtility.grayExtraLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CartPage.id);
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtility.deepYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
