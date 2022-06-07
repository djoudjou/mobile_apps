import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';

class ProfileSectionHeader extends SliverToBoxAdapter {
  ProfileSectionHeader(String text)
      : super(
          child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10.0),
              child: MyText(
                text,
                color: Colors.blueAccent,
                alignment: TextAlign.start,
              )),
        );
}
