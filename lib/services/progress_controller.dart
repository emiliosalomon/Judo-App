import 'package:flutter/foundation.dart';
import 'progress_store.dart';

/// Haelt den Lernfortschritt (welche Technik-IDs als "gelernt" markiert
/// sind) im Speicher und synchronisiert ihn mit [ProgressStore].
class ProgressController extends ChangeNotifier {
  final ProgressStore _store;
  late Set<String> _completed;

  ProgressController(this._store) {
    _completed = _store.read();
  }

  bool isCompleted(String id) => _completed.contains(id);

  void toggle(String id) {
    if (!_completed.add(id)) {
      _completed.remove(id);
    }
    notifyListeners();
    _store.write(_completed);
  }

  /// Markiert [id] als gelernt, ohne (anders als [toggle]) eine bereits
  /// gelernte ID wieder zu entfernen - fuer Faelle wie das Quiz, wo eine
  /// richtige Antwort den Lernstatus nur setzen, nie zuruecknehmen soll.
  void markLearned(String id) {
    if (_completed.add(id)) {
      notifyListeners();
      _store.write(_completed);
    }
  }

  /// Entfernt [id], falls markiert - Gegenstueck zu [markLearned] fuer
  /// Faelle wie die Quiz-"nochmal ueben"-Liste, aus der eine Technik
  /// verschwinden soll, sobald sie richtig beantwortet wurde.
  void unmark(String id) {
    if (_completed.remove(id)) {
      notifyListeners();
      _store.write(_completed);
    }
  }

  int countCompletedWithPrefix(String prefix) =>
      _completed.where((id) => id.startsWith(prefix)).length;

  /// Alle IDs mit [prefix], z.B. um die konkreten Technik-Namen einer
  /// Kategorie (nicht nur ihre Anzahl) aufzulisten.
  Iterable<String> idsWithPrefix(String prefix) =>
      _completed.where((id) => id.startsWith(prefix));
}
