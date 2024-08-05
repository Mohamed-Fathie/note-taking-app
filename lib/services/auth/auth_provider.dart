import 'package:freecodecamp/services/auth/auth_user.dart';

abstract class AuthProvifer {
  Future<void> inutualize();
  AuthUser? get currentUser;
  Future<AuthUser> loggin({
    required String email,
    required String password,
  });
  Future<AuthUser> creatUser({
    required String email,
    required String password,
  });
  Future<void> loggout();
  Future<void> sendvirefiction();
  Future<void> restpassword({required String toEmail});
}
