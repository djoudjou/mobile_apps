import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_entity.freezed.dart';

part 'event_entity.g.dart';

@freezed
class EventEntity with _$EventEntity {
  const EventEntity._(); // Added constructor
  const factory EventEntity({
    //@JsonKey(ignore: true)
    String? id,
    required int date,
    required String from,
    required String to,
    required String type,
    required bool seen,
    String? subject,
  }) = _EventEntity;

  factory EventEntity.fromDomain(Event event) {
    return EventEntity(
      id: event.id,
      date: event.date.getOrCrash(),
      from: event.from.id!,
      to: event.to.id!,
      type: event.type.toText,
      seen: event.seen,
      subject: event.subject,
    );
  }

  factory EventEntity.fromJson(Map<String, dynamic> json) =>
      _$EventEntityFromJson(json);

  factory EventEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return EventEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }
}
