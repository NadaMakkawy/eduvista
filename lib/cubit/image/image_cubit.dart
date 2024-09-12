// // // import 'package:bloc/bloc.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:file_picker/file_picker.dart';
// // // import 'package:flutter/foundation.dart';

// // // import 'image_state.dart';

// // // class ImageCubit extends Cubit<ImageState> {
// // //   ImageCubit() : super(ImageInitial());

// // //   // Function to pick an image and upload it to Firebase Storage
// // //   Future<void> pickAndUploadImage() async {
// // //     emit(ImageLoading());

// // //     try {
// // //       var imageResult = await FilePicker.platform
// // //           .pickFiles(type: FileType.image, withData: true);

// // //       if (imageResult != null) {
// // //         var storageRef = FirebaseStorage.instance
// // //             .ref('images/${imageResult.files.first.name}');
// // //         var uploadResult = await storageRef.putData(
// // //           imageResult.files.first.bytes!,
// // //           SettableMetadata(
// // //             contentType:
// // //                 'image/${imageResult.files.first.name.split('.').last}',
// // //           ),
// // //         );

// // //         if (uploadResult.state == TaskState.success) {
// // //           var downloadUrl = await uploadResult.ref.getDownloadURL();
// // //           if (kDebugMode) {
// // //             print('>>>>>Image upload: $downloadUrl');
// // //           }
// // //           emit(ImageSuccess(imageBytes: imageResult.files.first.bytes!));
// // //         }
// // //       } else {
// // //         emit(ImageError('No file selected'));
// // //       }
// // //     } catch (e) {
// // //       emit(ImageError(e.toString()));
// // //     }
// // //   }
// // // }
// // import 'package:bloc/bloc.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/foundation.dart';
// // import 'image_state.dart';

// // class ImageCubit extends Cubit<ImageState> {
// //   ImageCubit() : super(ImageInitial());

// //   // Function to pick an image and upload it to Firebase Storage
// //   Future<void> pickAndUploadImage() async {
// //     emit(ImageLoading());

// //     try {
// //       var imageResult = await FilePicker.platform
// //           .pickFiles(type: FileType.image, withData: true);

// //       if (imageResult != null) {
// //         var storageRef = FirebaseStorage.instance
// //             .ref('images/${imageResult.files.first.name}');
// //         var uploadResult = await storageRef.putData(
// //           imageResult.files.first.bytes!,
// //           SettableMetadata(
// //             contentType:
// //                 'image/${imageResult.files.first.name.split('.').last}',
// //           ),
// //         );

// //         if (uploadResult.state == TaskState.success) {
// //           var downloadUrl = await uploadResult.ref.getDownloadURL();

// //           // Save image URL to Firestore for the current user
// //           var currentUser = FirebaseAuth.instance.currentUser;
// //           if (currentUser != null) {
// //             await FirebaseFirestore.instance
// //                 .collection('users')
// //                 .doc(currentUser.uid)
// //                 .update({'profileImage': downloadUrl});
// //           }

// //           if (kDebugMode) {
// //             print('>>>>>Image upload: $downloadUrl');
// //           }
// //           emit(ImageSuccess(imageBytes: imageResult.files.first.bytes!));
// //         }
// //       } else {
// //         emit(ImageError('No file selected'));
// //       }
// //     } catch (e) {
// //       emit(ImageError(e.toString()));
// //     }
// //   }
// // }
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart';
// import 'image_state.dart';

// class ImageCubit extends Cubit<ImageState> {
//   ImageCubit() : super(ImageInitial()) {
//     _fetchUserProfileImage(); // Fetch image when cubit is initialized
//   }

//   // Fetch the profile image URL from Firestore
//   Future<void> _fetchUserProfileImage() async {
//     try {
//       var currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         var userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(currentUser.uid)
//             .get();

//         if (userDoc.exists && userDoc.data()!.containsKey('profileImage')) {
//           var imageUrl = userDoc.data()!['profileImage'];
//           var imageBytes = await _downloadImageFromUrl(imageUrl);
//           emit(ImageSuccess(imageBytes: imageBytes!));
//         }
//       }
//     } catch (e) {
//       emit(ImageError('Failed to load profile image: ${e.toString()}'));
//     }
//   }

//   // Download the image from the URL
//   Future<Uint8List?> _downloadImageFromUrl(String url) async {
//     try {
//       var imageData = await NetworkAssetBundle(Uri.parse(url)).load(url);
//       return imageData.buffer.asUint8List();
//     } catch (e) {
//       emit(ImageError('Failed to download image: ${e.toString()}'));
//       return null;
//     }
//   }

//   // Function to pick an image and upload it to Firebase Storage
//   Future<void> pickAndUploadImage() async {
//     emit(ImageLoading());

//     try {
//       var imageResult = await FilePicker.platform
//           .pickFiles(type: FileType.image, withData: true);

//       if (imageResult != null) {
//         var storageRef = FirebaseStorage.instance
//             .ref('images/${imageResult.files.first.name}');
//         var uploadResult = await storageRef.putData(
//           imageResult.files.first.bytes!,
//           SettableMetadata(
//             contentType:
//                 'image/${imageResult.files.first.name.split('.').last}',
//           ),
//         );

//         if (uploadResult.state == TaskState.success) {
//           var downloadUrl = await uploadResult.ref.getDownloadURL();

//           // Save image URL to Firestore for the current user
//           var currentUser = FirebaseAuth.instance.currentUser;
//           if (currentUser != null) {
//             await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(currentUser.uid)
//                 .update({'profileImage': downloadUrl});
//           }

//           var imageBytes = imageResult.files.first.bytes;
//           emit(ImageSuccess(imageBytes: imageBytes!));
//         }
//       } else {
//         emit(ImageError('No file selected'));
//       }
//     } catch (e) {
//       emit(ImageError(e.toString()));
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial()) {
    _fetchUserProfileImage(); // Fetch image when cubit is initialized
  }

  // Fetch the profile image URL from Firestore
  Future<void> _fetchUserProfileImage() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data()!.containsKey('profileImage')) {
          var imageUrl = userDoc.data()!['profileImage'];
          var imageBytes = await _downloadImageFromUrl(imageUrl);
          if (imageBytes != null) {
            emit(ImageSuccess(imageBytes: imageBytes));
          }
        }
      }
    } catch (e) {
      emit(ImageError('Failed to load profile image: ${e.toString()}'));
    }
  }

  // Download the image from the URL
  Future<Uint8List?> _downloadImageFromUrl(String url) async {
    try {
      var imageData = await NetworkAssetBundle(Uri.parse(url)).load(url);
      return imageData.buffer.asUint8List();
    } catch (e) {
      emit(ImageError('Failed to download image: ${e.toString()}'));
      return null;
    }
  }

  // Function to pick an image and upload it to Firebase Storage
  Future<void> pickAndUploadImage() async {
    emit(ImageLoading());

    try {
      var imageResult = await FilePicker.platform
          .pickFiles(type: FileType.image, withData: true);

      if (imageResult != null) {
        // A file is selected, proceed with upload
        var storageRef = FirebaseStorage.instance
            .ref('images/${imageResult.files.first.name}');
        var uploadResult = await storageRef.putData(
          imageResult.files.first.bytes!,
          SettableMetadata(
            contentType:
                'image/${imageResult.files.first.name.split('.').last}',
          ),
        );

        if (uploadResult.state == TaskState.success) {
          var downloadUrl = await uploadResult.ref.getDownloadURL();

          // Save image URL to Firestore for the current user
          var currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .update({'profileImage': downloadUrl});
          }

          var imageBytes = imageResult.files.first.bytes;
          emit(ImageSuccess(imageBytes: imageBytes!));
        }
      } else {
        // No file selected, fetch the latest image URL from Firestore
        var currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          var userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

          if (userDoc.exists && userDoc.data()!.containsKey('profileImage')) {
            var imageUrl = userDoc.data()!['profileImage'];
            var imageBytes = await _downloadImageFromUrl(imageUrl);
            if (imageBytes != null) {
              emit(ImageSuccess(imageBytes: imageBytes));
            }
          } else {
            emit(ImageError('No profile image found'));
          }
        }
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }
}
