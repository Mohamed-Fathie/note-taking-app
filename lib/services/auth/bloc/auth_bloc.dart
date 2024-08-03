import 'package:bloc/bloc.dart';
import 'package:freecodecamp/services/auth/auth_provider.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvifer provider)
      : super(const Uninitialized(isLoading: true)) {
    on<SendVerification>((event, emit) async {
      await provider.sendvirefiction();
      emit(state);
    });
    on<RegesteringEvent>((event, emit) async {
      final email = event.emial;
      final password = event.password;
      try {
        await provider.creatUser(email: email, password: password);
        await provider.sendvirefiction();
        emit(const Needsverificattion(isLoading: false));
      } on Exception catch (e) {
        emit(RegesterState(exception: e, isLoading: false));
      }
    });

    on<InitializationEvent>((event, emit) async {
      await provider.inutualize();
      final user = provider.currentUser;
      if (user == null) {
        emit(LoggedOutState(excpetion: null, isLoading: false));
      } else if (!user.isVerified) {
        emit(const Needsverificattion(isLoading: false));
      } else {
        emit(LoggedinState(user: user, isLoading: false));
      }
    });

    on<LogginEvent>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        emit(LoggedOutState(
            excpetion: null,
            isLoading: true,
            loadingtext: "wait until I log you in"));

        final user = await provider.loggin(
          email: email,
          password: password,
        );
        if (!user.isVerified) {
          emit(LoggedOutState(
            excpetion: null,
            isLoading: true,
          ));
          emit(const Needsverificattion(isLoading: false));
        }
        emit(LoggedOutState(excpetion: null, isLoading: false));
        emit(LoggedinState(user: user, isLoading: false));
      } on Exception catch (e) {
        emit(LoggedOutState(excpetion: e, isLoading: false));
      }
    });
    on<ShouldRegister>((event, emit) =>
        emit(const RegesterState(exception: null, isLoading: false)));
    on<LoggoutEvent>((event, emit) async {
      emit(LoggedOutState(excpetion: null, isLoading: true));
      try {
        await provider.loggout();
        emit(LoggedOutState(excpetion: null, isLoading: false));
      } on Exception catch (e) {
        emit(LoggedOutState(excpetion: e, isLoading: false));
      }
    });
  }
}
