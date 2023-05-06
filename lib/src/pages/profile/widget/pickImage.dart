import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharma_app/src/providers/user_provider.dart';
import 'package:vector_math/vector_math_64.dart';

class PickImage extends StatefulWidget {
  final Function(File pick) imagePickFn;

  const PickImage(this.imagePickFn);
  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? imageFile;

  final ImagePicker picker = ImagePicker();
  _pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });
    widget.imagePickFn(imageFile!);
  }

  Image image() {
    if (currentUser.value.imagePath != null && imageFile == null) {
      return Image(image: NetworkImage(currentUser.value.imagePath!));
    }
    if (imageFile != null) {
      return Image(image: FileImage(imageFile!));
    } else {
      return const Image(
          image: AssetImage('assets/immagini_pharma/logo_small.png'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Stack(
        children: [
          Container(
            width: 60,
            height: 60,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Material(
                  child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: image()),
                )),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: _pickImage,
              child: const Image(
                image: AssetImage('assets/immagini_pharma/foto.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
