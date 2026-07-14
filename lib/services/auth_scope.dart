import 'package:flutter/widgets.dart';
import 'auth_controller.dart';

/// Stellt den [AuthController] app-weit ueber den BuildContext bereit
/// (analog zu ProgressScope/StreakScope).
class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'No AuthScope found in context');
    return scope!.notifier!;
  }
}
