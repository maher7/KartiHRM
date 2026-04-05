import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseLocationStoreProvider {
  /// Stores the user's last-known location at:
  ///   companies/{companyId}/employee_track/{userId}
  ///
  /// SECURITY: company-scoped path so Firebase Security Rules can isolate tenants.
  /// If companyId is null, falls back to the legacy flat path for backward compat,
  /// but should be rare after login (login sets companyId in globalState).
  static Future sendLocationToFirebase(uid, location, {int? companyId}) async {
    if (Firebase.apps.isEmpty) return;
    final ref = companyId != null
        ? FirebaseFirestore.instance
            .collection('companies')
            .doc('$companyId')
            .collection('employee_track')
            .doc('$uid')
        : FirebaseFirestore.instance.collection('hrm_employee_track').doc('$uid');
    return ref.set(location).catchError((e) {
      debugPrint(e.toString());
    });
  }
}
