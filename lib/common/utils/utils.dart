import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showSnackBar(String content) {
  ScaffoldMessengerState scaffoldMessangerState = scaffoldKey.currentState!;
  scaffoldMessangerState.showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery() async {
  File? imageTemp;
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageTemp = File(image.path);
    }
  } catch (e) {
    showSnackBar(e.toString());
  }
  return imageTemp;
}
