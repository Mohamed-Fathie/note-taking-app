import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final bool isVerified;
  final String email;
  final String id;
  AuthUser({
    required this.email,
    required this.isVerified,
    required this.id,
  });

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
        isVerified: user.emailVerified, email: user.email!, id: user.uid);
  }
}
