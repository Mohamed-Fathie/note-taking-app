import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freecodecamp/firebase_options.dart';
import 'package:freecodecamp/services/auth/auth_excption.dart';
import 'package:freecodecamp/services/auth/auth_user.dart';
import 'package:freecodecamp/services/auth/auth_provider.dart';

class FirebaseAuthProvider implements AuthProvifer {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> creatUser({
    required email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotloggedin();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeekPassword();
        case 'email-already-in-use':
          throw Emailalreadyinuse();
        case 'invalid-email':
          throw InvalidEmail();
        case 'channel-error':
          throw Emptyfields();
        default:
          throw GenericException();
      }
    }
  }

  @override
  Future<AuthUser> loggin(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFound();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFound();
        case 'wrong-password':
          throw WrongPassword();
        case 'invalid-email':
          throw InvalidEmail();
        case 'invalid-credential':
          throw InvalidCredential();
        default:
          throw GenericException();
      }
    } catch (e) {
      throw GenericException();
    }
  }

  @override
  Future<void> loggout() async {
    final user = currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotloggedin();
    }
  }

  @override
  Future<void> sendvirefiction() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotloggedin();
    }
  }

  @override
  Future<void> inutualize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<bool> restpassword({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFound();
        case 'invalid-email':
          throw InvalidEmail();
        default:
          throw GenericException();
      }
    } catch (e) {
      return false;
    }
  }
}
