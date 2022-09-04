import 'dart:core';

import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_location_dto.g.dart';

@JsonSerializable()
class UpdateLocationDTO {
  String? name;
  String? address;
  String? photoUrl;

  UpdateLocationDTO({
    this.name,
    this.address,
    this.photoUrl,
  });

  factory UpdateLocationDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdateLocationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateLocationDTOToJson(this);
  factory UpdateLocationDTO.fromLocation(Location location) {
    return UpdateLocationDTO(
      name: location.title.getOrCrash(),
      address: location.address.getOrCrash(),
      photoUrl: location.photoUrl,
    );
  }
}
