abstract class AuthEvent {
  const AuthEvent();
}

class InitializationEvent extends AuthEvent {
  const InitializationEvent();
}

class LogginEvent extends AuthEvent {
  final String email;
  final String password;
  const LogginEvent(this.email, this.password);
}

class LoggoutEvent extends AuthEvent {
  const LoggoutEvent();
}

class RegesteringEvent extends AuthEvent {
  final String emial;
  final String password;
  const RegesteringEvent(this.emial, this.password);
}

class SendVerification extends AuthEvent {
  const SendVerification();
}

class ShouldRegister extends AuthEvent {
  const ShouldRegister();
}
