import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_history_entity.freezed.dart';
part 'children_lookup_history_entity.g.dart';

@freezed
class ChildrenLookupHistoryEntity with _$ChildrenLookupHistoryEntity {
  const ChildrenLookupHistoryEntity._(); // Added constructor

  const factory ChildrenLookupHistoryEntity({
    required int creationDate,
    required String id,
    required String subjectId,
    required String type,
    required String message,
  }) = _ChildrenLookupHistoryEntity;

  factory ChildrenLookupHistoryEntity.fromDomain(ChildrenLookupHistory domain) {
    return ChildrenLookupHistoryEntity(
      id: domain.id,
      creationDate: domain.creationDate.getOrCrash(),
      subjectId: domain.subject.id!,
      type: domain.eventType.toText,
      message: domain.message,
    );
  }

  factory ChildrenLookupHistoryEntity.fromJson(Map<String, dynamic> json) =>
      _$ChildrenLookupHistoryEntityFromJson(json);

  factory ChildrenLookupHistoryEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChildrenLookupHistoryEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }
}
