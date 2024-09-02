import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

import '../cubit/auth_cubit.dart';

import '../widgets/home/categories_widget.dart';
import '../widgets/course/courses_widget.dart';
import '../widgets/home/label_widget.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeMessage = 'Loading...';

  @override
  void initState() {
    _checkUserStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout(context: context);
            },
          ),
        ],
        title: Text(
          welcomeMessage,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              LabelWidget(
                name: 'Categories',
                onSeeAllClicked: () {},
              ),
              const CategoriesWidget(),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Rated Courses',
                onSeeAllClicked: () {},
              ),
              const CoursesWidget(
                rankValue: 'top rated',
              ),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Seller Courses',
                onSeeAllClicked: () {},
              ),
              const CoursesWidget(
                rankValue: 'top seller',
              ),
              ElevatedButton(
                  onPressed: () async {
                    var imageResult = await FilePicker.platform
                        .pickFiles(type: FileType.image, withData: true);
                    if (imageResult != null) {
                      var storageRef = FirebaseStorage.instance
                          .ref('images/${imageResult.files.first.name}');
                      var uploadResult = await storageRef.putData(
                          imageResult.files.first.bytes!,
                          SettableMetadata(
                            contentType:
                                'image/${imageResult.files.first.name.split('.').last}',
                          ));

                      if (uploadResult.state == TaskState.success) {
                        var downloadUrl =
                            await uploadResult.ref.getDownloadURL();
                        if (kDebugMode) {
                          print('>>>>>Image upload$downloadUrl');
                        }
                      }
                    } else {
                      if (kDebugMode) {
                        print('No file selected');
                      }
                    }
                  },
                  child: const Text('upload Image')),
              ElevatedButton(
                  onPressed: () async {
                    PaymobPayment.instance.initialize(
                      apiKey: dotenv.env[
                          'apiKey']!, // from dashboard Select Settings -> Account Info -> API Key
                      integrationID: int.parse(dotenv.env[
                          'integrationID']!), // from dashboard Select Developers -> Payment Integrations -> Online Card ID
                      iFrameID: int.parse(dotenv.env[
                          'iFrameID']!), // from paymob Select Developers -> iframes
                    );

                    final PaymobResponse? response =
                        await PaymobPayment.instance.pay(
                      context: context,
                      currency: "EGP",
                      amountInCents: "20000", // 200 EGP
                    );

                    if (response != null) {
                      if (kDebugMode) {
                        print('Response: ${response.transactionID}');
                      }
                      if (kDebugMode) {
                        print('Response: ${response.success}');
                      }
                    }
                  },
                  child: const Text('paymob pay'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(user.uid);

    final userData = await userDoc.get();
    if (userData.exists) {
      final isNew = userData.data()?['isNew'] ?? false;
      if (isNew) {
        setState(() {
          welcomeMessage = 'Welcome, ${user.displayName}';
        });
      } else {
        setState(() {
          welcomeMessage = 'Welcome back, ${user.displayName}';
        });
      }
    }
  }
}
