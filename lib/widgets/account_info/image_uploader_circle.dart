import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/image/image_cubit.dart';
import '../../cubit/image/image_state.dart';

class ImageUploaderCircle extends StatefulWidget {
  final double radius;
  Function()? onTap;

  ImageUploaderCircle({
    required this.radius,
    required this.onTap,
  });

  @override
  State<ImageUploaderCircle> createState() => _ImageUploaderCircleState();
}

class _ImageUploaderCircleState extends State<ImageUploaderCircle> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: BlocBuilder<ImageCubit, ImageState>(
        builder: (context, state) {
          Uint8List? _imageData;
          bool _isLoading = false;

          if (state is ImageLoading) {
            _isLoading = true;
          } else if (state is ImageSuccess) {
            _imageData = state.imageBytes;
            _isLoading = false;
          } else if (state is ImageError) {
            _isLoading = false;
            print(state.message);
          }

          return GestureDetector(
            child: CircleAvatar(
              radius: widget.radius,
              backgroundImage:
                  _imageData != null ? MemoryImage(_imageData) : null,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : _imageData == null
                      ? FittedBox(child: Icon(Icons.person, size: 50))
                      : null,
              backgroundColor: Colors.transparent,
            ),
            onTap: widget.onTap,
          );
        },
      ),
    );
  }
}
