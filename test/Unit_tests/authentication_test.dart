import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/services/auth/auth_excption.dart';
import 'package:freecodecamp/services/auth/auth_user.dart';
import 'package:freecodecamp/services/auth/auth_provider.dart';
import 'package:freecodecamp/services/auth_service.dart';

// Mock AuthProvider class
class MockAuthProvider implements AuthProvifer {
  AuthUser? _user;
  bool _initialized = false;
  bool _emailSent = false;

  @override
  Future<void> inutualize() async {
    _initialized = true;
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> creatUser(
      {required String email, required String password}) async {
    if (email == "existing@example.com") {
      throw Emailalreadyinuse();
    } else if (email == "invalid@example.com") {
      throw InvalidEmail();
    } else if (password == "weakpassword") {
      throw WeekPassword();
    }
    _user = AuthUser(email: email, isVerified: false, id: '123');
    return _user!;
  }

  @override
  Future<AuthUser> loggin(
      {required String email, required String password}) async {
    if (email == 'test@example.com' && password == 'password') {
      _user = AuthUser(email: email, isVerified: false, id: '123');
      return _user!;
    } else if (email == 'wrong@example.com') {
      throw UserNotFound();
    } else if (password == 'wrongpassword') {
      throw WrongPassword();
    } else {
      throw InvalidCredential();
    }
  }

  @override
  Future<void> loggout() async {
    if (_user == null) {
      throw UserNotloggedin();
    }
    _user = null;
  }

  @override
  Future<void> sendvirefiction() async {
    if (_user == null) {
      throw UserNotloggedin();
    }
    _emailSent = true;
  }
}

void main() {
  group('AuthService', () {
    late MockAuthProvider mockAuthProvider;
    late AuthService authService;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      authService = AuthService(mockAuthProvider);
    });

    test('createUser throws InvalidEmail on invalid email', () async {
      const email = 'invalid@example.com';
      const password = 'password';

      expect(
        () async =>
            await authService.creatUser(email: email, password: password),
        throwsA(isA<InvalidEmail>()),
      );
    });

    test('createUser throws WeekPassword on weak password', () async {
      const email = 'test@example.com';
      const password = 'weakpassword';

      expect(
        () async =>
            await authService.creatUser(email: email, password: password),
        throwsA(isA<WeekPassword>()),
      );
    });

    test('createUser calls provider createUser', () async {
      const email = 'test@example.com';
      const password = 'password';
      final user =
          await authService.creatUser(email: email, password: password);

      expect(user.email, email);
      expect(user.isVerified, false);
      expect(user.id, '123');
    });

    test('createUser throws Emailalreadyinuse on email already in use',
        () async {
      const email = 'existing@example.com';
      const password = 'password';

      expect(
        () async =>
            await authService.creatUser(email: email, password: password),
        throwsA(isA<Emailalreadyinuse>()),
      );
    });
    test('loggin throws InvalidCredential on invalid credentials', () async {
      const email = 'test@example.com';
      const password = 'invalidpassword';

      expect(
        () async => await authService.loggin(email: email, password: password),
        throwsA(isA<InvalidCredential>()),
      );
    });

    test('loggin calls provider loggin', () async {
      const email = 'test@example.com';
      const password = 'password';
      final user = await authService.loggin(email: email, password: password);

      expect(user.email, email);
      expect(user.isVerified, false);
      expect(user.id, '123');
    });

    test('loggin throws UserNotFound on user not found', () async {
      const email = 'wrong@example.com';
      const password = 'password';

      expect(
        () async => await authService.loggin(email: email, password: password),
        throwsA(isA<UserNotFound>()),
      );
    });

    test('loggin throws WrongPassword on wrong password', () async {
      const email = 'test@example.com';
      const password = 'wrongpassword';

      expect(
        () async => await authService.loggin(email: email, password: password),
        throwsA(isA<WrongPassword>()),
      );
    });

    test('loggout calls provider loggout', () async {
      await authService.creatUser(
          email: 'test@example.com', password: 'password');
      await authService.loggout();
      expect(mockAuthProvider.currentUser, null);
    });

    test('loggout throws UserNotloggedin when no user is logged in', () async {
      expect(() async => await authService.loggout(),
          throwsA(isA<UserNotloggedin>()));
    });

    test('sendvirefiction calls provider sendvirefiction', () async {
      await authService.creatUser(
          email: 'test@example.com', password: 'password');
      await authService.sendvirefiction();

      expect(mockAuthProvider._emailSent, true);
    });

    test('sendvirefiction throws UserNotloggedin when no user is logged in',
        () async {
      expect(() async => await authService.sendvirefiction(),
          throwsA(isA<UserNotloggedin>()));
    });

    test('inutualize calls provider inutualize', () async {
      await authService.inutualize();
      expect(mockAuthProvider._initialized, true);
    });

    test('currentUser returns provider currentUser', () async {
      await authService.creatUser(
          email: 'test@example.com', password: 'password');
      final user = authService.currentUser;

      expect(user?.email, 'test@example.com');
      expect(user?.isVerified, false);
      expect(user?.id, '123');
    });

    test('currentUser returns null when no user is logged in', () {
      final user = authService.currentUser;

      expect(user, isNull);
    });
  });
}
