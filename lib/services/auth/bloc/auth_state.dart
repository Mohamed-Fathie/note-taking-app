import 'package:freecodecamp/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState {
  const AuthState();
}

class Uninitialized extends AuthState {
  const Uninitialized();
}

class RegesterState extends AuthState {
  final Exception? exception;
  const RegesterState(this.exception);
}

//loggedin state
class LoggedinState extends AuthState {
  final AuthUser user;
  const LoggedinState(this.user);
}

// logged out state
class LoggedOutState extends AuthState with EquatableMixin {
  final Exception? excpetion;
  final bool isLoading;

  LoggedOutState({
    required this.excpetion,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [excpetion, isLoading];
}

// need virification
class Needsverificattion extends AuthState {
  const Needsverificattion();
}
