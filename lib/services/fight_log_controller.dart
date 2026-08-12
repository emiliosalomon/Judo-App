import 'package:flutter/foundation.dart';
import '../models/fight_entry.dart';
import 'fight_log_store.dart';

/// Haelt das Wettkampf-Tagebuch im Speicher und synchronisiert es mit
/// [FightLogStore].
class FightLogController extends ChangeNotifier {
  final FightLogStore _store;
  late List<FightEntry> _fights;

  FightLogController(this._store) {
    _fights = _sorted(_store.read());
  }

  /// Neueste Kaempfe zuerst.
  List<FightEntry> get fights => List.unmodifiable(_fights);

  void addFight(FightEntry fight) {
    _fights = _sorted([..._fights, fight]);
    notifyListeners();
    _store.write(_fights);
  }

  void removeFight(String id) {
    _fights = _fights.where((f) => f.id != id).toList();
    notifyListeners();
    _store.write(_fights);
  }

  List<FightEntry> _sorted(List<FightEntry> fights) =>
      [...fights]..sort((a, b) => b.date.compareTo(a.date));
}
