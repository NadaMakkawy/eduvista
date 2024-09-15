import 'package:eduvista/pages/payment_methods_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forex_currency_conversion/forex_currency_conversion.dart';

import '../cubit/pay/pay_cubit.dart';
import '../cubit/cart/cart_cubit.dart';

import '../models/cart_item.dart';

import '../utils/color_utilis.dart';

import '../widgets/course/course_tile_widget.dart';

import 'course_details_page.dart';

class CartPage extends StatefulWidget {
  static const String id = 'CartPage';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

          final fx = Forex();
          double totalInEGP = 0.0;

          double total = cartItems.fold(
              0, (sum, item) => sum + item.course.price! * item.quantity);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var course = cartItems[index].course;

                    return InkWell(
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
                      )),
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
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => PaymentMethodsPage(
                            onPressed: () async {
                              totalInEGP = await fx.getCurrencyConverted(
                                sourceCurrency: "USD",
                                destinationCurrency: "EGP",
                                sourceAmount: total,
                              );

                              await context.read<PayCubit>().payment(
                                  context, totalInEGP, 'EGP', cartItems);
                            },
                          ),
                        ),
                      ),
                      child: Text(
                        'Checkout',
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
