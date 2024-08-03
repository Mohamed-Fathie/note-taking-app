import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState {
  final bool isLoading;
  final String? text;
  const AuthState({required this.isLoading, this.text = "loading......"});
}

class Uninitialized extends AuthState {
  const Uninitialized({required bool isLoading}) : super(isLoading: isLoading);
}

class RegesterState extends AuthState {
  final Exception? exception;
  const RegesterState({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

//loggedin state
class LoggedinState extends AuthState {
  final AuthUser user;
  LoggedinState({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

// logged out state
class LoggedOutState extends AuthState with EquatableMixin {
  final Exception? excpetion;

  LoggedOutState(
      {required this.excpetion, required bool isLoading, String? loadingtext})
      : super(isLoading: isLoading, text: loadingtext);

  @override
  List<Object?> get props => [excpetion, isLoading];
}

// need virification
class Needsverificattion extends AuthState {
  const Needsverificattion({required bool isLoading})
      : super(isLoading: isLoading);
}
