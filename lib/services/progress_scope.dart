import 'package:flutter/widgets.dart';
import 'progress_controller.dart';

/// Stellt den [ProgressController] app-weit ueber den BuildContext bereit.
class ProgressScope extends InheritedNotifier<ProgressController> {
  const ProgressScope({
    super.key,
    required ProgressController controller,
    required super.child,
  }) : super(notifier: controller);

  static ProgressController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProgressScope>();
    assert(scope != null, 'No ProgressScope found in context');
    return scope!.notifier!;
  }
}
