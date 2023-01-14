import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart' as quiver;

class MyImage extends StatelessWidget {
  final String? imagePath;
  final String? photoUrl;
  final Image defaultImage;

  const MyImage({
    super.key,
    this.imagePath = '',
    this.photoUrl,
    required this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    if (quiver.isNotBlank(imagePath)) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.fill,
      );
    } else if (quiver.isNotBlank(photoUrl)) {
      return CachedNetworkImage(
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        imageUrl: photoUrl!,
        fit: BoxFit.fill,
      );
    } else {
      return defaultImage;
    }
  }
}
