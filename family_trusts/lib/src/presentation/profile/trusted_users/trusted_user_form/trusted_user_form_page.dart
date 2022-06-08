import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/profile/trusted_users/trusted_user_form/widgets/trusted_user_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrustedUserFormPage extends StatelessWidget with LogMixin {
  final User connectedUser;

  const TrustedUserFormPage({
    Key? key,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar(context: context, pageTitle: LocaleKeys.search_title.tr()),
      body: Center(
        child: BlocProvider<TrustedUserFormBloc>(
          create: (context) => getIt<TrustedUserFormBloc>(),
          child: TrustedUserForm(
            connectedUser: connectedUser,
          ),
        ),
      ),
    );
  }
}
