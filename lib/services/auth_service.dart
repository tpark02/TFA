import 'dart:io' show Platform;
import 'package:TFA/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // One GoogleSignIn instance; give iOS its clientId, others get null.
  final GoogleSignIn _gsi = GoogleSignIn(
    scopes: <String>['email'],
    clientId: (!kIsWeb && Platform.isIOS)
        ? DefaultFirebaseOptions.currentPlatform.iosClientId
        : null,
  );

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final GoogleAuthProvider provider = GoogleAuthProvider()
        ..setCustomParameters(<dynamic, dynamic>{'prompt': 'select_account'});
      return _auth.signInWithPopup(provider);
    }

    final GoogleSignInAccount? gUser = await _gsi.signIn();
    if (gUser == null) {
      throw FirebaseAuthException(code: 'aborted', message: 'User cancelled');
    }
    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    final OAuthCredential cred = GoogleAuthProvider.credential(
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
