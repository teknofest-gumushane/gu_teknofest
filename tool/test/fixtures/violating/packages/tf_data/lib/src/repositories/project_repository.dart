import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/src/widgets/button.dart';

abstract class ProjectRepository {
  Future<void> delete(String id);
  Future<void> deleteProject(String id) async {
    await doc(id).delete();
    await deleteDoc(doc(id));
    await doc(id).update({'cover': FieldValue.delete()});
  }
}
