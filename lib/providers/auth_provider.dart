// lib/providers/auth_provider.dart
import 'package:TFA/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
