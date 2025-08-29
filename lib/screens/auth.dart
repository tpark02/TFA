import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/utils/api_config.dart';
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

  bool _isLogin = true;
  bool _isSubmitting = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _form.currentState;
    if (form == null) return;
    if (!form.validate()) return;
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

      // Verify with backend using fresh ID token
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
    final t = Theme.of(context).textTheme;
    final text = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(20),
                elevation: 0,
                color: Colors.transparent,
                // shadowColor: Colors.black.withValues(alpha: 0.4),
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
                        Text(
                          _isLogin ? text.login_in : text.create_account,
                          style: t.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.primaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            labelText: text.email_addr,
                            prefixIcon: const Icon(Icons.email_outlined),
                            errorStyle: TextStyle(
                              color:
                                  Colors.red.shade600, // <- Your custom color
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

                        // Password
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
                              color:
                                  Colors.red.shade600, // <- Your custom color
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

                        // Submit
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: cs.primaryContainer,
                              foregroundColor: cs.onPrimaryContainer,
                              disabledBackgroundColor: cs.primaryContainer
                                  .withValues(alpha: .4),
                              disabledForegroundColor: cs.onPrimaryContainer
                                  .withValues(alpha: .6),
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
                                : Text(_isLogin ? text.login : text.sign_up),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Switch mode
                        TextButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin ? text.create_account : text.i_already,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
