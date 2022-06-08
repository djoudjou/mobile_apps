import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/location/bloc.dart';
import 'package:familytrusts/src/domain/location/complex_address.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/search/search_address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchAddressForm extends StatelessWidget {
  final OnSelectAddressCallback onSelectAddressCallback;

  const SearchAddressForm({
    Key? key,
    required this.onSelectAddressCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchLocationBloc, SearchLocationState>(
      listener: (context, state) {
        state.searchLocationFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              showErrorMessage(
                failure.map(
                  serverError: (_) => LocaleKeys.global_serverError.tr(),
                ),
                context,
              );
            },
            (_) {},
          ),
        );
      },
      child: BlocBuilder<SearchLocationBloc, SearchLocationState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const MyVerticalSeparator(),
                addressLookupText(context),
                const MyVerticalSeparator(),
                buildResult(state, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget addressLookupText(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: LocaleKeys.location_search_title.tr(),
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      onChanged: (value) => context
          .read<SearchLocationBloc>()
          .add(SearchLocationEvent.addressLookupChanged(value)),
    );
  }

  Widget buildResult(SearchLocationState state, BuildContext context) {
    if (state.isSubmitting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return state.searchLocationFailureOrSuccessOption.fold(
        () => Container(),
        (searchLocationFailureOrSuccess) => searchLocationFailureOrSuccess.fold(
          (searchUserFailure) => Center(
            child: MyText(LocaleKeys.global_serverError.tr()),
          ),
          (result) {
            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final ComplexAddress complexAddress = result[index];
                  return ListTile(
                    onTap: () => onSelectAddressCallback(
                      SelectAddressParams(
                        position: complexAddress.position,
                        photoUrl: complexAddress.photoUrl,
                        address: complexAddress.address,
                      ),
                    ),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        complexAddress.address!,
                        maxLines: 2,
                      ),
                    ),
                    leading: const Icon(Icons.location_on),
                  );
                },
                itemCount: result.length,
              ),
            );
          },
        ),
      );
    }
  }
}
