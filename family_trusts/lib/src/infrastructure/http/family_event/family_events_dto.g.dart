// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_events_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyEventsDTO _$FamilyEventsDTOFromJson(Map<String, dynamic> json) =>
    FamilyEventsDTO(
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => FamilyEventDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      nbNotSeen: json['nbNotSeen'] as int?,
    );

Map<String, dynamic> _$FamilyEventsDTOToJson(FamilyEventsDTO instance) =>
    <String, dynamic>{
      'events': instance.events,
      'nbNotSeen': instance.nbNotSeen,
    };
