import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../dialogs/FullImage.dart';

class ZoomableImage extends StatelessWidget {
  final String imageUrl;
  final String? zoomUrl;

  const ZoomableImage({Key? key, required this.imageUrl, this.zoomUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Material(
                    child: Container(
                      child: Stack(
                        children: [
                          PhotoView(
                            //heroAttributes: PhotoViewHeroAttributes(tag: 'post_photo'+zoomUrl),
                            imageProvider: CachedNetworkImageProvider(
                              zoomUrl!,
                            ),
                            // Contained = the smallest possible size to fit one dimension of the screen
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            // Covered = the smallest possible size to fit the whole screen
                            maxScale: PhotoViewComputedScale.covered * 2,
                            loadingBuilder: (context, event) => Center(
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            top: 32,
                            child: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
        },
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: ((zoomUrl != null && zoomUrl!.endsWith('.gif'))
              ? zoomUrl
              : imageUrl)!,
          placeholder: (context, url) => Image.asset(
            'assets/immagini/loading.gif',
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
