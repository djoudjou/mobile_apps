import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';

part 'location_entity.freezed.dart';
part 'location_entity.g.dart';

@freezed
class LocationEntity with _$LocationEntity {
  const LocationEntity._(); // Added constructor
  const factory LocationEntity({
    String? id,
    required String title,
    required String address,
    required String note,
    @JsonKey(ignore: true)
    GeoPoint? position,
    String? photoUrl,
  }) = _LocationEntity;

  factory LocationEntity.fromDomain(Location location) {
    final LatLng latLng = location.gpsPosition.value.toOption().toNullable()!;
    return LocationEntity(
      id: location.id,
      title: location.title.getOrCrash(),
      address: location.address.getOrCrash(),
      position: GeoPoint(
        latLng.latitude,
        latLng.longitude,
      ),
      photoUrl: location.photoUrl,
      note: location.note.getOrCrash(),
    );
  }

  Location toDomain() {
    return Location(
      id: id,
      photoUrl: photoUrl,
      address: Address(address),
      title: Name(title),
      gpsPosition: GpsPosition.fromPosition(
        latitude: position!.latitude,
        longitude: position!.longitude,
      ),
      note: NoteBody(note),
    );
  }

  factory LocationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocationEntityFromJson(json);

  factory LocationEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>>doc) {
    return LocationEntity.fromJson(doc.data()!).copyWith(
      id: doc.id,
    );
  }

/*
  @override
  Map<String, dynamic> toJson() {
    log("To JSON ADJ >>>>>>> $this");
    return {
      fieldId: id,
      fieldPhotoUrl: photoUrl,
      "title": title,
      "address": address,
      "position": position,
      "note": note,
    };
  }

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      id: json[fieldId] as String,
      title: json["title"] as String,
      address: json["title"] as String,
      position: json["position"] as GeoPoint,
      photoUrl: json[fieldPhotoUrl] as String,
      note: json["note"] as String,
    );
  }

  factory LocationEntity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>>snap) {
    return LocationEntity(
      id: snap.id,
      title: snap.data()["title"] as String,
      address: snap.data()["title"] as String,
      position: snap.data()["position"] as GeoPoint,
      photoUrl: snap.data()[fieldPhotoUrl] as String,
      note: snap.data()["note"] as String,
    );
  }

 */
}
