import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial()) {
    _fetchUserProfileImage();
  }

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

  Future<Uint8List?> _downloadImageFromUrl(String url) async {
    try {
      var imageData = await NetworkAssetBundle(Uri.parse(url)).load(url);
      return imageData.buffer.asUint8List();
    } catch (e) {
      emit(ImageError('Failed to download image: ${e.toString()}'));
      return null;
    }
  }

  Future<void> pickAndUploadImage() async {
    emit(ImageLoading());

    try {
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
          ),
        );

        if (uploadResult.state == TaskState.success) {
          var downloadUrl = await uploadResult.ref.getDownloadURL();

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
