// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_lookup_history_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChildrenLookupHistoryEntity _$$_ChildrenLookupHistoryEntityFromJson(
        Map<String, dynamic> json) =>
    _$_ChildrenLookupHistoryEntity(
      creationDate: json['creationDate'] as int,
      id: json['id'] as String,
      subjectId: json['subjectId'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$$_ChildrenLookupHistoryEntityToJson(
        _$_ChildrenLookupHistoryEntity instance) =>
    <String, dynamic>{
      'creationDate': instance.creationDate,
      'id': instance.id,
      'subjectId': instance.subjectId,
      'type': instance.type,
      'message': instance.message,
    };
