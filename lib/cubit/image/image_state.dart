import 'package:flutter/foundation.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageSuccess extends ImageState {
  final Uint8List imageBytes;
  ImageSuccess({required this.imageBytes});
}

class ImageError extends ImageState {
  final String message;
  ImageError(this.message);
}
