import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/auth_provider.dart';
import 'package:TFA/utils/api_config.dart';
import 'package:TFA/widgets/google_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _firebase = FirebaseAuth.instance;

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwCtrl = TextEditingController();
  bool busy = false;
  bool _isLogin = true;
  bool _isSubmitting = false;
  bool _showPassword = false;

  Future<void> _google() async {
    setState(() => busy = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _form.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    final email = _emailCtrl.text.trim();
    final password = _pwCtrl.text;
    setState(() => _isSubmitting = true);
    try {
      UserCredential creds;
      if (_isLogin) {
        creds = await _firebase.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        creds = await _firebase.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      try {
        final idToken = await creds.user!.getIdToken(true);
        final res = await http.get(
          getBackendUri(),
          headers: <String, String>{'Authorization': 'Bearer $idToken'},
        );
        if (!mounted) return;
        if (res.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Server rejected token')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isLogin ? 'Welcome back!' : 'Account created ✅'),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to verify with backend')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg = switch (e.code) {
        'email-already-in-use' => 'Email is already in use.',
        'user-not-found' => 'No user found for that email.',
        'wrong-password' => 'Incorrect password.',
        'invalid-email' => 'Invalid email address.',
        'network-request-failed' => 'Network error. Please try again.',
        _ => 'Authentication failed.',
      };
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: cs.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/cloud.jpg', fit: BoxFit.cover),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Spacer(),
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: Theme.of(
                            context,
                          ).textTheme.displayLarge!.fontSize,
                          color: cs.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Card(
                        margin: const EdgeInsets.all(20),
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _form,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailCtrl,
                                  decoration: InputDecoration(
                                    labelText: text.email_addr,
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    final v = (value ?? '').trim();
                                    if (v.isEmpty || !v.contains('@')) {
                                      return text.please_enter_email;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _pwCtrl,
                                  decoration: InputDecoration(
                                    labelText: text.password,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  obscureText: !_showPassword,
                                  validator: (value) {
                                    final v = value ?? '';
                                    if (v.length < 6) {
                                      return text.password_must_be;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: _isSubmitting ? null : _submit,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: cs.primaryContainer,
                                      foregroundColor: cs.onPrimaryContainer,
                                      disabledBackgroundColor: cs
                                          .primaryContainer
                                          .withValues(alpha: .4),
                                      disabledForegroundColor: cs
                                          .onPrimaryContainer
                                          .withValues(alpha: .6),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isSubmitting
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            _isLogin
                                                ? text.login
                                                : text.sign_up,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => setState(
                                          () => _isLogin = !_isLogin,
                                        ),
                                  child: Text(
                                    _isLogin
                                        ? text.create_account
                                        : text.i_already,
                                    style: TextStyle(color: cs.onPrimary),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Divider(thickness: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        "OR",
                                        style: TextStyle(color: cs.onPrimary),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(thickness: 1),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: GoogleButton(
                                    onPressed: busy ? null : _google,
                                    loading: busy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100, width: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
