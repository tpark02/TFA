import 'dart:io' show Platform;
import 'package:TFA/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final _auth = FirebaseAuth.instance;

  // One GoogleSignIn instance; give iOS its clientId, others get null.
  final GoogleSignIn _gsi = GoogleSignIn(
    scopes: ['email'],
    clientId: (!kIsWeb && Platform.isIOS)
        ? DefaultFirebaseOptions.currentPlatform.iosClientId
        : null,
  );

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});
      return _auth.signInWithPopup(provider);
    }

    final gUser = await _gsi.signIn();
    if (gUser == null) {
      throw FirebaseAuthException(code: 'aborted', message: 'User cancelled');
    }
    final gAuth = await gUser.authentication;
    final cred = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );
    return _auth.signInWithCredential(cred);
  }

  Future<void> signOut() async {
    try {
      await _gsi.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
