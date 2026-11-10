import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class ProjectRepository {
  Future<void> delete(String id);
  Future<void> deleteProject(String id) async {
    await doc(id).delete();
    await deleteDoc(doc(id));
    await doc(id).update({'cover': FieldValue.delete()});
  }
}
