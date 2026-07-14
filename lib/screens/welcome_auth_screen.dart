import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../services/auth_scope.dart';
import '../theme/judo_theme.dart';
import 'login_register_screen.dart';

/// Erster Bildschirm, wenn Firebase konfiguriert ist und noch keine
/// Anmelde-Entscheidung getroffen wurde: Anmelden, Registrieren, oder ohne
/// Anmeldung fortfahren (Gast-Modus, Daten werden nicht gespeichert).
class WelcomeAuthScreen extends StatelessWidget {
  const WelcomeAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sports_martial_arts,
                size: 96,
                color: JudoColors.red,
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.authWelcomeTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.authWelcomeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _openAuth(context, AuthFormMode.login),
                  child: const Text(AppStrings.authLoginButton),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _openAuth(context, AuthFormMode.register),
                  child: const Text(AppStrings.authRegisterButton),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => AuthScope.of(context).continueAsGuest(),
                child: const Text(AppStrings.authContinueAsGuestButton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAuth(BuildContext context, AuthFormMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginRegisterScreen(initialMode: mode)),
    );
  }
}
