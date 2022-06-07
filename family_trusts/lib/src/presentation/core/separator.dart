import 'package:flutter/material.dart';

class MyVerticalSeparator extends StatelessWidget {
  const MyVerticalSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}

class MyHorizontalSeparator extends StatelessWidget {
  const MyHorizontalSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 8);
  }
}
