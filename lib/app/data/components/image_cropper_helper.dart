import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropperHelper {
  Future<File?> pickAndCropImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recadrer l’image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Recadrer l’image',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    }
    return null;
  }
}
