import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.url,
    required this.radius,
  });

  const Avatar.small({
    super.key,
    required this.url,
    this.radius = 16,
  });

  const Avatar.medium({
    super.key,
    required this.url,
    this.radius = 22,
  });

  const Avatar.large({
    super.key,
    required this.url,
    this.radius = 44,
  });

  final double radius;
  final String url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(url),
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
