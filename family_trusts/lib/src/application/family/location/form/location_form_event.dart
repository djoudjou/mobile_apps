import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_form_event.freezed.dart';

@freezed
abstract class LocationFormEvent with _$LocationFormEvent {
  const factory LocationFormEvent.init(String? familyId, Location location) =
      LocationInit;

  const factory LocationFormEvent.noteChanged(String note) = NoteChanged;

  const factory LocationFormEvent.titleChanged(String title) = TitleChanged;

  const factory LocationFormEvent.addressChanged(String address) =
      AddresChanged;

  const factory LocationFormEvent.latLngChanged(LatLng position) =
      LatLngChanged;

  const factory LocationFormEvent.picturePathChanged(String pickedFilePath) =
      PicturePathChanged;

  const factory LocationFormEvent.pictureUrlChanged(String pickedFileUrl) =
      PictureUrlChanged;

  const factory LocationFormEvent.saveLocation({
    required User connectedUser,
    String? pickedFilePath,
    required Location location,
  }) = SaveLocation;

  const factory LocationFormEvent.deleteLocation({
    required User connectedUser,
    required Location location,
  }) = DeleteLocation;
}
