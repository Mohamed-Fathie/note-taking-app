import 'package:freecodecamp/services/auth/auth_provider.dart';
import 'package:freecodecamp/services/auth/auth_user.dart';
import 'package:freecodecamp/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvifer {
  AuthProvifer provider;
  AuthService(this.provider);
  factory AuthService.firebase() {
    return AuthService(FirebaseAuthProvider());
  }

  @override
  Future<AuthUser> creatUser({required email, required String password}) =>
      provider.creatUser(
        email: email,
        password: password,
      );

  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> loggin({required email, required String password}) =>
      provider.loggin(
        email: email,
        password: password,
      );

  @override
  Future<void> loggout() => provider.loggout();

  @override
  Future<void> sendvirefiction() => provider.sendvirefiction();

  @override
  Future<void> inutualize() => provider.inutualize();
}
