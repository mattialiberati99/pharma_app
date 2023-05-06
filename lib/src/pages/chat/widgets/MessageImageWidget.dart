// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../elements/ZoomableImage.dart';
import '../../../models/media.dart';

class MessageImageWidget extends StatelessWidget {
  final Media media;
  const MessageImageWidget({Key? key,required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
          height: 200,
          child: ZoomableImage(
            imageUrl: media.thumb!,
            zoomUrl: media.url,
          )),
    );
  }
}
