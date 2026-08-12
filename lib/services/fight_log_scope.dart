import 'package:flutter/widgets.dart';
import 'fight_log_controller.dart';

/// Stellt den [FightLogController] app-weit ueber den BuildContext bereit.
class FightLogScope extends InheritedNotifier<FightLogController> {
  const FightLogScope({
    super.key,
    required FightLogController controller,
    required super.child,
  }) : super(notifier: controller);

  static FightLogController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FightLogScope>();
    assert(scope != null, 'No FightLogScope found in context');
    return scope!.notifier!;
  }
}
