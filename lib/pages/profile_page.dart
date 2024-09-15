import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../cubit/auth/auth_cubit.dart';

import '../pages/pending_cart_page.dart';

import '../widgets/account_info/image_uploader_circle.dart';
import '../widgets/account_info/gray_container_list_tile_widget.dart';

class ProfilePage extends StatelessWidget {
  static const String id = 'ProfilePage';
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => PendingCartPage(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageUploaderCircle(radius: 70, onTap: () {}),
            SizedBox(height: 16),
            Text(
              '${user?.displayName?[0].toUpperCase()}${user?.displayName?.substring(1)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '${user?.email}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 70),
            GrayContainerListTileWidget(
              label: 'Edit',
              onTap: () {},
            ),
            SizedBox(height: 25),
            GrayContainerListTileWidget(
              label: 'Settings',
              onTap: () {},
            ),
            SizedBox(height: 25),
            GrayContainerListTileWidget(
              label: 'About Us',
              onTap: () {},
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout(context: context);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
