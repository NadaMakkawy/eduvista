import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

import '../cart/cart_cubit.dart';

import '../../models/cart_item.dart';

import '../../pages/purchased_courses_page.dart';

part 'pay_state.dart';

class PayCubit extends Cubit<PayState> {
  PayCubit() : super(PayInitial());

  Future<void> payment(BuildContext context, double totalPrice, String currency,
      List<CartItem> cartItems) async {
    PaymobPayment.instance.initialize(
      apiKey: dotenv.env['apiKey']!,
      integrationID: int.parse(dotenv.env['integrationID']!),
      iFrameID: int.parse(dotenv.env['iFrameID']!),
    );

    final PaymobResponse? response = await PaymobPayment.instance.pay(
      context: context,
      currency: currency,
      amountInCents: (totalPrice * 100).toString(), // 200 EGP
    );

    if (response != null) {
      if (kDebugMode) {
        print('Response: ${response.transactionID}');
      }
      if (kDebugMode) {
        print('Response: ${response.success}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful')),
      );

      await handlePurchase(cartItems, context);

      context.read<CartCubit>().clearCart();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => PurchasedCoursesPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed, please try again')),
      );
    }
  }

  Future<void> handlePurchase(
      List<CartItem> cartItems, BuildContext context) async {
    await context.read<CartCubit>().purchaseCourses(context, cartItems);
  }
}
