import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Spiegelt ein einzelnes JSON-Dokument pro angemeldetem Konto in Firestore
/// (Sammlung "user_data", Dokument-ID = UID). Best effort: schlaegt Netz
/// oder Firebase fehl, bleibt die App mit den lokalen Daten voll nutzbar -
/// wie [FirestoreLeaderboardRepository] das fuer die Rangliste schon macht.
class CloudSync {
  static bool get isAvailable => Firebase.apps.isNotEmpty;

  static const _collection = 'user_data';

  /// Liefert das gespeicherte Dokument fuer [uid], oder null wenn nicht
  /// verfuegbar/noch keins vorhanden/Fehler.
  static Future<Map<String, dynamic>?> pull(String uid) async {
    if (!isAvailable) return null;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(_collection)
          .doc(uid)
          .get();
      return snapshot.data();
    } catch (_) {
      return null;
    }
  }

  /// Schreibt [fields] ins Dokument von [uid] (merge, ueberschreibt nur die
  /// uebergebenen Felder). Wartet nicht auf Erfolg - Aufrufer sollen dadurch
  /// nicht blockiert werden.
  static void push(String uid, Map<String, dynamic> fields) {
    if (!isAvailable) return;
    FirebaseFirestore.instance
        .collection(_collection)
        .doc(uid)
        .set(fields, SetOptions(merge: true))
        .catchError((_) {});
  }
}
