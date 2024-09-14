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
                  fontSize: 20,
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
                        )),
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
                                onPressed: () {},
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    ColorUtility.grayExtraLight,
                                  ),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  totalInEGP = await fx.getCurrencyConverted(
                                    sourceCurrency: "USD",
                                    destinationCurrency: "EGP",
                                    sourceAmount: total,
                                  );

                                  await context.read<PayCubit>().payment(
                                      context, totalInEGP, 'EGP', cartItems);
                                },
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    ColorUtility.deepYellow,
                                  ),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
              Text('Total: \$${total.toString()}'),
              ElevatedButton(
                onPressed: () async {
                  totalInEGP = await fx.getCurrencyConverted(
                    sourceCurrency: "USD",
                    destinationCurrency: "EGP",
                    sourceAmount: total,
                  );

                  await context
                      .read<PayCubit>()
                      .payment(context, totalInEGP, 'EGP', cartItems);
                },
                child: Text('Purchase'),
              ),
            ],
          );
        },
      ),
    );
  }
}
