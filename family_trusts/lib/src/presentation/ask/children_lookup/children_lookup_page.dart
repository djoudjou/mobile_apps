import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/children_lookup/bloc.dart';
import 'package:familytrusts/src/presentation/ask/children_lookup/widgets/children_lookup_form.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildrenLookupPage extends StatelessWidget {
  final String currentUserId;
  final String? currentFamilyId;

  const ChildrenLookupPage({
    Key? key,
    required this.currentUserId,
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
        create: (context) => getIt<ChildrenLookupBloc>()
          ..add(ChildrenLookupEvent.init(currentFamilyId)),
        child: ChildrenLookupForm(
          connectedUserId: currentUserId,
        ),
      ),
    );
  }
}
