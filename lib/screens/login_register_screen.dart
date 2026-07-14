import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../services/auth_scope.dart';

enum AuthFormMode { login, register }

/// Formular fuer Anmeldung und Registrierung in einem - ueber
/// [AppStrings.authSwitchToRegister]/[AppStrings.authSwitchToLogin] laesst
/// sich zwischen beiden Modi wechseln, ohne den Screen zu verlassen.
class LoginRegisterScreen extends StatefulWidget {
  final AuthFormMode initialMode;

  const LoginRegisterScreen({super.key, required this.initialMode});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthFormMode _mode;
  bool _submitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isLogin => _mode == AuthFormMode.login;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final auth = AuthScope.of(context);
    final error = _isLogin
        ? await auth.signIn(_emailController.text, _passwordController.text)
        : await auth.register(_emailController.text, _passwordController.text);
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _submitting = false;
      _errorText = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLogin ? AppStrings.authLoginTitle : AppStrings.authRegisterTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: AppStrings.authEmailLabel,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? AppStrings.authEmailRequired
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: AppStrings.authPasswordLabel,
                  ),
                  validator: (value) => (value == null || value.length < 6)
                      ? AppStrings.authPasswordTooShort
                      : null,
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isLogin
                              ? AppStrings.authLoginSubmit
                              : AppStrings.authRegisterSubmit,
                        ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => setState(() {
                          _mode = _isLogin
                              ? AuthFormMode.register
                              : AuthFormMode.login;
                          _errorText = null;
                        }),
                  child: Text(
                    _isLogin
                        ? AppStrings.authSwitchToRegister
                        : AppStrings.authSwitchToLogin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
