import 'package:TFA/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final StreamProvider<User?> authStateProvider = StreamProvider<User?>(
  (StreamProviderRef<User?> ref) => FirebaseAuth.instance.authStateChanges(),
);
final Provider<AuthService> authServiceProvider = Provider<AuthService>((ProviderRef<AuthService> ref) => AuthService());
