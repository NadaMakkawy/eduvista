import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/pay/pay_cubit.dart';
import '../cubit/cart/cart_cubit.dart';

import '../models/cart_item.dart';

class CartPage extends StatelessWidget {
  static const String id = 'CartPage';

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
                  await context
                      .read<PayCubit>()
                      .payment(context, total, 'EGP', cartItems);
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
