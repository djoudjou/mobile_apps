import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_image.dart';
import 'package:flutter/material.dart';

class SearchUserCard extends StatelessWidget {
  final User user;

  const SearchUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 12.0,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              ProfileImage(
                imageTag: "IMAGE_TAG_${user.id}",
                editable: false,
                image: MyImage(
                  photoUrl: user.photoUrl,
                  defaultImage: const Image(image: defaultUserImages),
                ),
                radius: 40,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MyText(user.displayName),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
