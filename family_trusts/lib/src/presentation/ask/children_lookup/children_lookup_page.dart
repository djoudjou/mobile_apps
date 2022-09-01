import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/children_lookup/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/ask/children_lookup/widgets/children_lookup_form.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildrenLookupPage extends StatelessWidget {
  final User connectedUser;
  final String? currentFamilyId;

  const ChildrenLookupPage({
    Key? key,
    required this.connectedUser,
    this.currentFamilyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        pageTitle: LocaleKeys.ask_childlookup_title.tr(),
        context: context,
      ),
      body: BlocProvider<ChildrenLookupBloc>(
        create: (context) => ChildrenLookupBloc(
          getIt<IFamilyRepository>(),
          getIt<IChildrenLookupRepository>(),
        )..add(ChildrenLookupEvent.init(currentFamilyId)),
        child: ChildrenLookupForm(
          connectedUser: connectedUser,
        ),
      ),
    );
  }
}
