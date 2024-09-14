import 'package:flutter/material.dart';

import '../utils/color_utilis.dart';

class PaymentMethodsPage extends StatefulWidget {
  static const String id = 'PaymentMethodsPage';

  final void Function()? onPressed;

  PaymentMethodsPage({required this.onPressed});

  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Payment Methods',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
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
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selectedPaymentMethod == 'Paymob'
                      ? Colors.white
                      : ColorUtility.grayExtraLight,
                  border: Border.all(
                      color: selectedPaymentMethod == 'Paymob'
                          ? ColorUtility.deepYellow
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Paymob',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Radio<String>(
                      value: 'Paymob',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      },
                      activeColor: ColorUtility.deepYellow,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 35,
              ),
              child: ElevatedButton(
                onPressed:
                    selectedPaymentMethod != null ? widget.onPressed : null,
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: selectedPaymentMethod != null
                      ? WidgetStatePropertyAll(ColorUtility.deepYellow)
                      : WidgetStatePropertyAll(ColorUtility.grayLight),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  minimumSize:
                      WidgetStatePropertyAll(Size(double.infinity, 50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
