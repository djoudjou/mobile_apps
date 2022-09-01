import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/children_lookup/details/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/ask/children_lookup/widgets/children_lookup_details_content.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildrenLookupDetailsPage extends StatelessWidget {
  final ChildrenLookup childrenLookup;
  final User connectedUser;

  const ChildrenLookupDetailsPage({
    Key? key,
    required this.childrenLookup,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        pageTitle: LocaleKeys.childlookupDetails_title.tr(),
        context: context,
      ),
      body: BlocProvider<ChildrenLookupDetailsBloc>(
        create: (context) =>
            ChildrenLookupDetailsBloc(getIt<IChildrenLookupRepository>())
              ..add(
                ChildrenLookupDetailsEvent.init(
                  childrenLookup: childrenLookup,
                  connectedUser: connectedUser,
                ),
              ),
        child: ChildrenLookupDetailsContent(
          connectedUser: connectedUser,
        ),
      ),
    );
  }
}
