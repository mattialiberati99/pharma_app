import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dialogs/UploadChooseDialog.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ChatHelper {
  static void tagTap(BuildContext context, String text) {
    launchUrl(Uri.parse(text));
  }

  static showUploadMediaDialog(chatProv, chatId, BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    showDialog(
        context: context,
        builder: (_) => UploadChooseDialog(onCamera: () async {
              Navigator.of(context).pop();
              // Capture a photo
              final XFile? photo =
                  await _picker.pickImage(source: ImageSource.camera);
              if (photo != null) {
                final shrinked = await adaptImage(File(photo.path));
                chatProv.sendImageMessage(chatId, shrinked);
              }
            }, onMemory: () async {
              Navigator.of(context).pop();
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                final shrinked = await adaptImage(File(image.path));
                chatProv.sendImageMessage(chatId, shrinked);
              }
            }));
  }

  static Future<File> adaptImage(File? picked) async {
    img.Image? image = img.decodeImage(await picked!.readAsBytesSync());

    // Resize the image to a 1080x? thumbnail (maintaining the aspect ratio).
    img.Image thumbnail = await img.copyResize(image!, width: 1080);
    String dir = (await getTemporaryDirectory()).path;
    final file = new File(dir + "/temp_" + path.basename(picked.path));
    // Save the thumbnail as a PNG.
    print(file.path);
    return file..writeAsBytesSync(img.encodePng(thumbnail));
  }
}
