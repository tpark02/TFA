import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});
      return await _auth.signInWithPopup(provider);
    }
    final gUser = await GoogleSignIn(scopes: ['email']).signIn();
    if (gUser == null) {
      throw FirebaseAuthException(code: 'aborted', message: 'User cancelled');
    }
    final gAuth = await gUser.authentication;
    final cred = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );
    return await _auth.signInWithCredential(cred);
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
