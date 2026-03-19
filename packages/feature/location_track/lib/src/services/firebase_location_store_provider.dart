import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseLocationStoreProvider {
  static Future sendLocationToFirebase(uid, location) async {
    if (Firebase.apps.isEmpty) return;
    return FirebaseFirestore.instance
        .collection('hrm_employee_track')
        .doc('$uid')
        .set(location)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }
}
