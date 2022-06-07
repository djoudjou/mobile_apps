import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
