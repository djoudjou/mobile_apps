import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/location/bloc.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/search/widgets/search_address_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef OnSelectAddressCallback = Function(SelectAddressParams params);

class SelectAddressParams {
  final LatLng? position;
  final String? address;
  final String? photoUrl;

  SelectAddressParams({
    this.position,
    this.address,
    this.photoUrl,
  });
}

class SearchAddressPage extends StatelessWidget {
  final OnSelectAddressCallback onSelectAddressCallback;

  const SearchAddressPage({super.key, required this.onSelectAddressCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        pageTitle: LocaleKeys.location_search_title.tr(),
      ),
      body: Center(
        child: BlocProvider<SearchLocationBloc>(
          create: (context) => SearchLocationBloc(),
          child: SearchAddressForm(
            onSelectAddressCallback: onSelectAddressCallback,
          ),
        ),
      ),
    );
  }
}
