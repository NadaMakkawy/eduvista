import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/pending_cart_page.dart';

import '../utils/color_utilis.dart';

import '../widgets/home/course_filter_chips_widget.dart';

import 'chat_page.dart';

class ChatUsersPage extends StatelessWidget {
  static const String id = 'ChatUsersPage';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, PendingCartPage.id);
            },
          ),
        ],
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
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return Column(
          children: [
            CourseFilterChipsWidget(),
            Expanded(
              child: ListView(
                children: snapshot.data!.docs
                    .map<Widget>((doc) => _buildUserListItem(doc, context))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document, BuildContext context) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.displayName != data['displayName']) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserName: data['displayName'],
                  receiverUserID: data['uid'] ?? 'unknown',
                  image: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(data['profileImage'] ??
                        'https://via.placeholder.com/150'),
                  ),
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    data['profileImage'] ?? 'https://via.placeholder.com/150'),
              ),
              SizedBox(width: 20),
              Text(
                data['displayName'],
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
