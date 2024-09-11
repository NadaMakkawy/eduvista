// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';

// import '../../utils/color_utilis.dart';

// class UploadImageerCircle extends StatefulWidget {
//   @override
//   _UploadImageerCircleState createState() => _UploadImageerCircleState();
// }

// class _UploadImageerCircleState extends State<UploadImageerCircle> {
//   Uint8List? _imageData;
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//             child: CircleAvatar(
//               radius: 20,
//               backgroundImage:
//                   _imageData != null ? MemoryImage(_imageData!) : null,
//               child: _isLoading
//                   ? SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(),
//                     )
//                   : _imageData == null
//                       ? FittedBox(child: Icon(Icons.person, size: 30))
//                       : null,
//               backgroundColor: ColorUtility.deepYellow,
//             ),
//             onTap: () async {
//               setState(() {
//                 _isLoading = true;
//               });
//               var imageResult = await FilePicker.platform
//                   .pickFiles(type: FileType.image, withData: true);
//               if (imageResult != null) {
//                 var storageRef = FirebaseStorage.instance
//                     .ref('images/${imageResult.files.first.name}');
//                 var uploadResult = await storageRef.putData(
//                   imageResult.files.first.bytes!,
//                   SettableMetadata(
//                     contentType:
//                         'image/${imageResult.files.first.name.split('.').last}',
//                   ),
//                 );

//                 if (uploadResult.state == TaskState.success) {
//                   var downloadUrl = await uploadResult.ref.getDownloadURL();
//                   if (kDebugMode) {
//                     print('>>>>>Image upload: $downloadUrl');
//                   }
//                   setState(() {
//                     _imageData = imageResult.files.first.bytes!;
//                   });
//                 }
//               } else {
//                 if (kDebugMode) {
//                   print('No file selected');
//                 }
//               }
//               setState(() {
//                 _isLoading = false;
//               });
//             }),
//       ],
//     );
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/image/image_cubit.dart';
import '../../cubit/image/image_state.dart';
import '../../utils/color_utilis.dart';

class ImageUploaderCircle extends StatelessWidget {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          return GestureDetector(
            child: CircleAvatar(
              radius: 20,
              backgroundImage:
                  _imageData != null ? MemoryImage(_imageData) : null,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : _imageData == null
                      ? FittedBox(child: Icon(Icons.person, size: 30))
                      : null,
              backgroundColor: ColorUtility.deepYellow,
            ),
            onTap: () => context.read<ImageCubit>().pickAndUploadImage(),
          );
        },
      ),
    );
  }
}
