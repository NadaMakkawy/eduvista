import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/home/search_chips_list_widget.dart';

import '../models/category_item.dart';

import '../pages/cart_page.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var futureCall = FirebaseFirestore.instance.collection('categories').get();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, CartPage.id);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future: futureCall,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error occurred'),
                    );
                  }

                  if (!snapshot.hasData ||
                      (snapshot.data?.docs.isEmpty ?? false)) {
                    return const Center(
                      child: Text('No categories found'),
                    );
                  }

                  var categories = List<CategoryItem>.from(snapshot.data?.docs
                          .map((e) =>
                              CategoryItem.fromJson({'id': e.id, ...e.data()}))
                          .toList() ??
                      []);

                  return SearchChipsListWidget(categories: categories);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
