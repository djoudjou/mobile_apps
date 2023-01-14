import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/core/api_keys.dart';
import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

typedef OnSelectPlaceCallback = Function(OnSelectPlaceParams params);

class OnSelectPlaceParams {
  final String address;
  final String photoUrl;
  final LatLng position;

  OnSelectPlaceParams({
    required this.address,
    required this.photoUrl,
    required this.position,
  });
}

class SelectPlacePickerInput extends StatefulWidget {
  final LatLng currentPosition;
  final OnSelectPlaceCallback onSelectPlaceCallback;

  const SelectPlacePickerInput({
    super.key,
    required this.currentPosition,
    required this.onSelectPlaceCallback,
  });

  @override
  State<SelectPlacePickerInput> createState() => _SelectPlacePickerInputState();
}

class _SelectPlacePickerInputState extends State<SelectPlacePickerInput>
    with LogMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      //style: RoundedRectangleBorder(
      //  borderRadius: BorderRadius.circular(30.0),
      //),
      label: MyText(LocaleKeys.location_form_placePicker_label.tr()),
      icon: const Icon(Icons.location_on),
      onPressed: () {
        context.pushRoute(
          SelectPlacePickerPageRoute(
            key: const ValueKey("SelectPlacePickerPage"),
            currentPosition: widget.currentPosition,
            onSelectPlaceCallback: widget.onSelectPlaceCallback,
          ),
        );
      },
    );
  }
}

class SelectPlacePickerPage extends StatelessWidget with LogMixin {
  final LatLng currentPosition;
  final OnSelectPlaceCallback? onSelectPlaceCallback;

  const SelectPlacePickerPage({
    super.key,
    required this.currentPosition,
    this.onSelectPlaceCallback,
  });

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: ApiKeys.googleApiKey,
      initialPosition: currentPosition,
      useCurrentLocation: true,
      selectInitialPosition: true,
      //autocompleteLanguage: ,
      //usePlaceDetailSearch: true,
      //forceSearchOnZoomChanged: true,
      //automaticallyImplyAppBarLeading: false,
      //autocompleteLanguage: "ko",
      //region: 'au',

      selectedPlaceWidgetBuilder:
          (bc, selectedPlace, state, isSearchBarFocused) {
        return isSearchBarFocused
            ? Container()
            : _placeWidgetBuilder(bc, selectedPlace!, state);
      },
    );
  }

  Widget _placeWidgetBuilder(
    BuildContext context,
    PickResult data,
    SearchingState state,
  ) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.05,
      leftPosition: MediaQuery.of(context).size.width * 0.025,
      rightPosition: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.9,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching
          ? _buildLoadingIndicator()
          : _buildSelectionDetails(context, data),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 48,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    int selectedPhoto = 0;
    final CarouselController buttonCarouselController = CarouselController();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            result.formattedAddress!,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (result.photos != null && result.photos!.isNotEmpty) ...[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 150,
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    //color: Colors.blue,
                    child: IconButton(
                      onPressed: () => buttonCarouselController.previousPage(),
                      icon: const Icon(Icons.skip_previous),
                    ),
                  ),
                  SizedBox(
                    //color: Colors.grey,
                    width: MediaQuery.of(context).size.width * 0.8 - 80,
                    child: CarouselSlider.builder(
                      carouselController: buttonCarouselController,
                      itemCount: result.photos!.length,
                      options: CarouselOptions(
                        //autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 2.0,
                        onPageChanged:
                            (int index, CarouselPageChangedReason reason) {
                          selectedPhoto = index;
                          log("selected $index");
                        },
                        //initialPage: 0,
                      ),
                      itemBuilder: (
                        BuildContext context,
                        int itemIndex,
                        int pageViewIndex,
                      ) =>
                          Container(
                        child: MyImage(
                          photoUrl: _buildPhotoURL(
                            result.photos![itemIndex].photoReference,
                          ),
                          defaultImage: const Image(
                            image: defaultLocationImages,
                          ), // todo : il faut une image pa défaut pour cet écran
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    //color: Colors.green,
                    width: 40,
                    child: IconButton(
                      onPressed: () => buttonCarouselController.nextPage(),
                      icon: const Icon(Icons.skip_next),
                    ),
                  ),
                ],
              ),
            )
          ],
          ElevatedButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
              minimumSize: const Size(88, 36),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
            onPressed: () {
              //onPlacePicked(result);
              if (onSelectPlaceCallback != null) {
                onSelectPlaceCallback!(
                  OnSelectPlaceParams(
                    address: result.formattedAddress!,
                    photoUrl: _buildPhotoURL(
                      result.photos != null && result.photos!.isNotEmpty
                          ? result.photos![selectedPhoto].photoReference
                          : '',
                    ),
                    position: LatLng(
                      result.geometry!.location.lat,
                      result.geometry!.location.lng,
                    ),
                  ),
                );
                context.popRoute();
              }
            },
            child: MyText(
              LocaleKeys.location_form_placePicker_select.tr(),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _buildPhotoURL(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=${ApiKeys.googleApiKey}";
  }
}
