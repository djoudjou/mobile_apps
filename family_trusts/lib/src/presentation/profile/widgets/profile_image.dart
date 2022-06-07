import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnUpdatePhotoUrlCallback = Function(
    BuildContext context, String downloadUrl);
typedef OnClickOnPhotoCallback = Function(BuildContext context);

class ProfileImage extends StatelessWidget {
  final Widget image;
  final double radius;
  final OnClickOnPhotoCallback? onClickOnPhotoCallback;
  final OnUpdatePhotoUrlCallback? onUpdatePictureFilePathCallback;
  final String imageTag;
  final bool editable;
  final _picker = ImagePicker();

  ProfileImage({
    required this.imageTag,
    this.radius = 20.0,
    required this.image,
    this.onClickOnPhotoCallback,
    this.onUpdatePictureFilePathCallback,
    required this.editable,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => editable
          ? modifyProfilPicture(context)
          : onClickOnPhotoCallback != null
              ? onClickOnPhotoCallback!(context)
              : null,
      child: Hero(
        tag: imageTag,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: image,
            ),
          ),
        ),
      ),
    );
  }

  void modifyProfilPicture(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            color: Colors.transparent,
            child: Card(
              elevation: 5.0,
              margin: const EdgeInsets.all(7.5),
              child: Container(
                color: Colors.white70,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const MyText(
                      "Modification de la photo",
                      color: Colors.blue,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                            icon: camIcon,
                            onPressed: () {
                              takePicture(context, ImageSource.camera);
                              Navigator.pop(ctx);
                            }),
                        IconButton(
                            icon: libIcon,
                            onPressed: () {
                              takePicture(context, ImageSource.gallery);
                              Navigator.pop(ctx);
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> takePicture(BuildContext context, ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxHeight: 500.0,
      maxWidth: 500.0,
    );
    if (image != null && onUpdatePictureFilePathCallback != null) {
      onUpdatePictureFilePathCallback!(context, image.path);
    }
  }
}
