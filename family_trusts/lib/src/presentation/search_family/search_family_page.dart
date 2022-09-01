import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family_search/search_family_bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/page/my_base_page.dart';
import 'package:familytrusts/src/presentation/search_family/widgets/search_family_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchFamilyPage extends MyBasePage {
  SearchFamilyPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget myBuild(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        pageTitle: LocaleKeys.search_family_title.tr(),
      ),
      body: Center(
        child: BlocProvider<SearchFamilyBloc>(
          create: (context) => SearchFamilyBloc(getIt<IFamilyRepository>()),
          child: const SearchFamilyForm(),
        ),
      ),
    );
  }

  @override
  void refresh(BuildContext context) {
    // TODO: implement refresh
  }
}
