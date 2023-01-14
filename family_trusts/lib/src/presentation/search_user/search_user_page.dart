import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/search_user/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/search_user/widgets/search_user_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUserPage extends StatelessWidget {
  final User connectedUser;
  final bool lookingForNewTrustUser;

  const SearchUserPage({
    super.key,
    required this.connectedUser,
    required this.lookingForNewTrustUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar(context: context, pageTitle: LocaleKeys.search_title.tr()),
      body: Center(
        child: BlocProvider<SearchUserBloc>(
          create: (context) => SearchUserBloc(
            getIt<IUserRepository>(),
            getIt<IAuthFacade>(),
          ),
          child: SearchUserForm(
            connectedUser: connectedUser,
            lookingForNewTrustUser: lookingForNewTrustUser,
          ),
        ),
      ),
    );
  }
}
