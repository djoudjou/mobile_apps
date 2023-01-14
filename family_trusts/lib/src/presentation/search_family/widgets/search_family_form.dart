import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family_search/search_family_bloc.dart';
import 'package:familytrusts/src/application/family_search/search_family_event.dart';
import 'package:familytrusts/src/application/family_search/search_family_state.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/search_family/widgets/search_family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchFamilyForm extends StatelessWidget {
  const SearchFamilyForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchFamilyBloc, SearchFamilyState>(
      listener: (searchFamilyBlocContext, state) {
        state.searchFamilyFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              showErrorMessage(
                failure.map(
                  serverError: (_) => LocaleKeys.global_serverError.tr(),
                ),
                searchFamilyBlocContext,
              );
            },
            (_) {},
          ),
        );
      },
      child: BlocBuilder<SearchFamilyBloc, SearchFamilyState>(
        builder: (searchFamilyBlocContext, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const MyVerticalSeparator(),
                familyLookupText(searchFamilyBlocContext),
                const MyVerticalSeparator(),
                const Divider(),
                buildResult(state, searchFamilyBlocContext),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget familyLookupText(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: LocaleKeys.search_family_familyLookupText.tr(),
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      onChanged: (value) => context
          .read<SearchFamilyBloc>()
          .add(SearchFamilyEvent.familyLookupChanged(value)),
    );
  }

  Widget buildResult(SearchFamilyState state, BuildContext context) {
    if (state.isSubmitting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return state.searchFamilyFailureOrSuccessOption.fold(
        () => Container(),
        (searchFamilyFailureOrSuccess) => searchFamilyFailureOrSuccess.fold(
          (searchFamilyFailure) => Center(
            child: MyText(LocaleKeys.global_serverError.tr()),
          ),
          (result) {
            final List<Family> families = result;
            return families.isEmpty
                ? Column(
                  children: [
                    const MyVerticalSeparator(),
                    const MyVerticalSeparator(),
                    const MyVerticalSeparator(),
                    Align(
                        child: MyText(
                          LocaleKeys.search_family_no_result.tr(),
                          maxLines: 3,
                        ),
                      ),
                  ],
                )
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final Family selectedFamily = families[index];
                        return InkWell(
                          onTap: () async {
                            await AlertHelper().confirm(
                              context,
                              LocaleKeys.profile_sendTrustProposal
                                  .tr(args: [selectedFamily.displayName]),
                              onConfirmCallback: () {
                                AutoRouter.of(context).pop(selectedFamily);
                              },
                            );
                          },
                          child: SearchFamilyCard(family: selectedFamily),
                        );
                      },
                      itemCount: families.length,
                    ),
                  );
          },
        ),
      );
    }
  }
}
