import 'dart:async';
import 'package:familytrusts/src/domain/family/child.dart';

abstract class ChildRepository {
  Future<void> addChild(Child child);

  Future<void> deleteChild(Child child);

  Stream<List<Child>> getChildren(String familyId);

  Future<void> updateChild(Child child);
}
