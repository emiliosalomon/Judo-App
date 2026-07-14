import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/screens/login_register_screen.dart';
import 'package:judo_app/screens/welcome_auth_screen.dart';
import 'package:judo_app/services/auth_controller.dart';
import 'package:judo_app/services/auth_scope.dart';
import 'package:judo_app/services/auth_service.dart';
import 'package:judo_app/services/guest_choice_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AuthController> pumpWelcomeScreen(WidgetTester tester) async {
    final controller = AuthController(
      AuthService(),
      await GuestChoiceStore.load(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: AuthScope(
          controller: controller,
          child: const WelcomeAuthScreen(),
        ),
      ),
    );
    return controller;
  }

  testWidgets('zeigt Anmelden, Registrieren und Gast-Option', (tester) async {
    await pumpWelcomeScreen(tester);

    expect(find.text(AppStrings.authLoginButton), findsOneWidget);
    expect(find.text(AppStrings.authRegisterButton), findsOneWidget);
    expect(find.text(AppStrings.authContinueAsGuestButton), findsOneWidget);
  });

  testWidgets('Anmelden oeffnet das Login-Formular', (tester) async {
    await pumpWelcomeScreen(tester);

    await tester.tap(find.text(AppStrings.authLoginButton));
    await tester.pumpAndSettle();

    expect(find.byType(LoginRegisterScreen), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, AppStrings.authLoginSubmit),
      findsOneWidget,
    );
  });

  testWidgets(
    'Login-Formular zeigt Validierungsfehler bei leerer E-Mail/zu kurzem '
    'Passwort',
    (tester) async {
      final controller = AuthController(
        AuthService(),
        await GuestChoiceStore.load(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: AuthScope(
            controller: controller,
            child: const LoginRegisterScreen(initialMode: AuthFormMode.login),
          ),
        ),
      );

      await tester.tap(
        find.widgetWithText(FilledButton, AppStrings.authLoginSubmit),
      );
      await tester.pump();

      expect(find.text(AppStrings.authEmailRequired), findsOneWidget);
      expect(find.text(AppStrings.authPasswordTooShort), findsOneWidget);
    },
  );

  testWidgets('Ohne Anmeldung fortfahren setzt den Gast-Status', (
    tester,
  ) async {
    final controller = await pumpWelcomeScreen(tester);

    await tester.tap(find.text(AppStrings.authContinueAsGuestButton));
    await tester.pump();

    expect(controller.status, AuthStatus.guest);
  });
}
