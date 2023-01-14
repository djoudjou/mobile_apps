import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:flutter/material.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: LoadingContent(),
      ),
    );
  }
}
