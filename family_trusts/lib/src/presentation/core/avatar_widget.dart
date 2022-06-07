import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnTapCallback = Function();

class MyAvatar extends StatelessWidget {
  final String? photoUrl;
  final String imageTag;
  final double radius;
  final AssetImage defaultImage;
  final OnTapCallback onTapCallback;

  const MyAvatar({
    Key? key,
    this.photoUrl,
    required this.onTapCallback,
    required this.imageTag,
    required this.radius,
    required this.defaultImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ProfileImage(
            imageTag: imageTag,
            radius: radius * .8,
            image: MyImage(
              photoUrl: photoUrl,
              defaultImage: Image(image: defaultImage),
            ),
            editable: false,
            onClickOnPhotoCallback: (_) => onTapCallback(),
          ),
        ],
      ),
    );
  }
}
