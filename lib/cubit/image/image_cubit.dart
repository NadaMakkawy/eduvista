import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial());

  // Function to pick an image and upload it to Firebase Storage
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
          if (kDebugMode) {
            print('>>>>>Image upload: $downloadUrl');
          }
          emit(ImageSuccess(imageBytes: imageResult.files.first.bytes!));
        }
      } else {
        emit(ImageError('No file selected'));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }
}
