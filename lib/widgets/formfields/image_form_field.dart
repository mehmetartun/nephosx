import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/enums.dart';
import '../../services/image_utils.dart';

class ImageFormfield extends FormField<String> {
  ImageFormfield({
    Key? key,
    FormFieldValidator<String>? onValidate,
    FormFieldSetter<String>? onSaved,
    String? initialValue,
  }) : super(
         validator: onValidate,
         onSaved: onSaved,
         initialValue: initialValue,
         builder: (state) {
           return _ImageFormField(state: state);
         },
       );
}

class _ImageFormField extends StatefulWidget {
  const _ImageFormField({required this.state});
  final FormFieldState<String> state;

  @override
  State<_ImageFormField> createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<_ImageFormField> {
  final TransformationController _transformationController =
      TransformationController();

  void _pickImage(context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final ImageCropper cropper = ImageCropper();
      CroppedFile? croppedFile = await cropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          // AndroidUiSettings(
          //   toolbarTitle: 'Crop Image',
          //   toolbarColor: Colors.deepOrange,
          //   toolbarWidgetColor: Colors.white,
          //   initAspectRatio: CropAspectRatioPreset.original,
          //   lockAspectRatio: false,
          // ),
          // IOSUiSettings(title: 'Crop Image'),
          WebUiSettings(context: context),
        ],
      );
      if (croppedFile == null) return;
      final Uint8List imageBytes = await ImageUtils.xFileToUint8List(
        XFile(croppedFile.path),
      );
      final String thumbnail = ImageUtils.createThumbnail(imageBytes);
      widget.state.didChange(thumbnail);
    }
  }

  @override
  void initState() {
    super.initState();
    // Center the image initially.
    _transformationController.value = Matrix4.identity()..translate(0.0, 0.0);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = widget.state.value != null
        ? ImageUtils.parseBase64Image(widget.state.value!)
        : null;

    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: ClipOval(
            child: Container(
              color: Colors.grey.shade300,
              child: imageBytes == null
                  ? const Center(child: Icon(Icons.person, size: 80))
                  : InteractiveViewer(
                      transformationController: _transformationController,
                      // minScale: 0.1,
                      // maxScale: 4.0,
                      // Boundary is a square of 200x200
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      child: Image.memory(imageBytes, fit: BoxFit.cover),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
              onPressed: () {
                _pickImage(context);
              },
              child: const Text('Change Image'),
            ),
            // if (imageBytes != null) ...[
            //   const SizedBox(width: 8),
            //   FilledButton.tonal(
            //     onPressed: _cropAndSave,
            //     child: const Text('Crop'),
            //   ),
            // ],
          ],
        ),
      ],
    );
  }

  // void _cropAndSave() async {
  //   final imageBytes = ImageUtils.parseBase64Image(widget.state.value!);
  //   if (imageBytes == null) return;

  //   // Get the transformation matrix
  //   final Matrix4 matrix = _transformationController.value;

  //   // Decompose the matrix to get scale and translation
  //   final vector.Vector3 translation = matrix.getTranslation();
  //   final vector.Vector3 scale = vector.Vector3.zero();
  //   final vector.Quaternion rotation = vector.Quaternion.identity();
  //   matrix.decompose(translation, rotation, scale);

  //   // The size of our circular viewport
  //   const double viewportSize = 200.0;

  //   // Calculate the crop area in the coordinate system of the scaled image
  //   final double cropX = -translation.x / scale.x;
  //   final double cropY = -translation.y / scale.y;
  //   final double cropSize = viewportSize / scale.x;

  //   final croppedImageBytes = await ImageUtils.cropImage(
  //     imageBytes,
  //     cropX.round(),
  //     cropY.round(),
  //     cropSize.round(),
  //     cropSize.round(),
  //   );

  //   if (croppedImageBytes != null) {
  //     final String finalBase64 = ImageUtils.createThumbnail(croppedImageBytes);
  //     widget.state.didChange(finalBase64);
  //   }
  // }
}
