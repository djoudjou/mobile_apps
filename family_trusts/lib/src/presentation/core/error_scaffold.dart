import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:flutter/material.dart';

class ErrorScaffold extends StatelessWidget {
  const ErrorScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ErrorContent(),
      ),
    );
  }
}
