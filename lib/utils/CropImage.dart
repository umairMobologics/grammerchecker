

  import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> cropImage( {required File imagefile}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagefile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust your Image',
          toolbarColor: mainClr,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false
        ),
        IOSUiSettings(
          title: 'Adjust your Image',
        ),
        
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
      
    }
    
    return null;
  }
     