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

  int countCompletedWithPrefix(String prefix) =>
      _completed.where((id) => id.startsWith(prefix)).length;
}
