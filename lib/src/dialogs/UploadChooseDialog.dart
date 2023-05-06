// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import '../helpers/helper.dart';

class UploadChooseDialog extends StatelessWidget {
  final Function onCamera;
  final Function onMemory;

  const UploadChooseDialog({Key? key, required this.onCamera,required this.onMemory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(64.0)),
      ),
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(64.0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(64.0)),
                onTap: () => onCamera(),
                child: const Center(
                  child: Icon(Icons.camera_alt),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(64.0)),
                onTap: () =>onMemory(),
                child: const Center(
                  child: Icon(Icons.perm_media_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}