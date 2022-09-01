import 'dart:core';

import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDTO {
  String? locationId;
  String? name;
  String? address;
  String? photoUrl;

  LocationDTO({
    this.locationId,
    this.name,
    this.address,
    this.photoUrl,
  });

  factory LocationDTO.fromJson(Map<String, dynamic> json) =>
      _$LocationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDTOToJson(this);

  Location toDomain() {
    // TODO ADJ missing gpsposition, note on backend
    return Location(
      id: locationId,
      address: Address(address!),
      note: NoteBody(""),
      gpsPosition: GpsPosition.fromPosition(latitude: 0, longitude: 0),
      title: Name(name),
      photoUrl: photoUrl,
    );
  }
}
