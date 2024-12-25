import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/core/utils/CropImage.dart';
import 'package:grammar_checker_app_updated/core/utils/extractText.dart';
import 'package:grammar_checker_app_updated/core/utils/snackbar.dart';
import 'package:image_picker/image_picker.dart';

// Global flag to check if an operation is in progress
var isOperationInProgress = false.obs;

// Pick image from camera
Future<bool> pickImageFromCamera(textController) async {
  if (isOperationInProgress.value) return false;

  isOperationInProgress.value = true;
  try {
    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return false;
    File? img = File(imageFile.path);

    // Crop the selected image
    img = await cropImage(imagefile: img);

    // Extract text from cropped image
    String allExtractedText = '';
    final extractedText = await extractTextFromImage(img);
    if (extractedText.isNotEmpty) {
      allExtractedText += '$extractedText\n';
    }

    if (allExtractedText.trim().isNotEmpty) {
      print("Text Extracted");
      textController.controller.value.text = allExtractedText;
      return true;
    } else {
      CustomSnackbar.showSnackbar(
          "Failed to extract text", SnackPosition.BOTTOM);
      return true;
    }
  } catch (e) {
    print("Error: $e");
    CustomSnackbar.showSnackbar("Failed to extract text", SnackPosition.BOTTOM);
    return true;
  } finally {
    isOperationInProgress.value = false;
  }
}

// Pick image from gallery
Future<bool> pickImageFromGallery(textController) async {
  if (isOperationInProgress.value) return false;

  isOperationInProgress.value = true;
  try {
    final picker = ImagePicker();
    final List<XFile> imageFiles = await picker.pickMultiImage();
    if (imageFiles.isEmpty) return false;

    List<File?> images = [];
    for (XFile imageFile in imageFiles) {
      File? img = File(imageFile.path);
      // Crop the selected image
      img = await cropImage(imagefile: img);
      images.add(img);
    }

    // Extract text from cropped images
    String allExtractedText = '';
    for (File? img in images) {
      final extractedText = await extractTextFromImage(img);
      if (extractedText.isNotEmpty) {
        allExtractedText += '$extractedText\n';
      }
    }

    if (allExtractedText.trim().isNotEmpty) {
      print("Text Extracted");
      textController.controller.value.text = allExtractedText;
      return true;
    } else {
      CustomSnackbar.showSnackbar(
          "Failed to extract text", SnackPosition.BOTTOM);
      return true;
    }
  } catch (e) {
    CustomSnackbar.showSnackbar("Failed to extract text", SnackPosition.BOTTOM);

    log("Error: $e");
    return true;
  } finally {
    isOperationInProgress.value = false;
  }
}

Future<File?> getImagefromGallery() async {
  try {
    File? _image = null;
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // Crop the selected image
      _image = await cropImage(imagefile: _image);
      if (_image != null) {
        return _image;
      }
      return null;
    } else {
      print('No image selected.');
      return null;
    }
  } catch (e) {
    log("error, $e");
    return null;
  }
}
