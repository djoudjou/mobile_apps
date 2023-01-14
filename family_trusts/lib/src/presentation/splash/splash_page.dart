import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/presentation/core/page/my_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends MyBasePage {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SplashPage({super.key});

  @override
  Widget myBuild(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        log("SplashPage user state #$state#");
        return Scaffold(
          key: _scaffoldKey,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // TODO ADJ add a pretty splash animation
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void refresh(BuildContext context) {

  }
}
