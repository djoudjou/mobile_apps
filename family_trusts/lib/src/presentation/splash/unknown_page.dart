import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/page/my_base_page.dart';
import 'package:flutter/material.dart';

class UnknownPage extends MyBasePage {
  UnknownPage({super.key});

  @override
  Widget myBuild(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            MyText("Unknown Page"),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  void refresh(BuildContext context) {

  }
}
