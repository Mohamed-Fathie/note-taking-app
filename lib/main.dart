import 'package:flutter/material.dart';
import 'package:freecodecamp/helper/loading_screen.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';
import 'package:freecodecamp/services/auth/firebase_auth_provider.dart';
import 'package:freecodecamp/view/forgot_password_screen.dart';
import 'package:freecodecamp/view/loginscreen.dart';
import 'package:freecodecamp/view/note/create_update_note.dart';
import 'package:freecodecamp/view/note/note_view.dart';
import 'package:freecodecamp/view/register_view.dart';
import 'package:freecodecamp/view/verifyemail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'register',
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      '/login/': (context) => const LoginScreen(),
      '/register/': (context) => const RegisterScreen(),
      '/note/': (context) => const NoteView(),
      '/newnote/': (context) => const CreatOrUpdateNote(),
      '/verified/': (context) => const VerifyEmail(),
    },
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const InitializationEvent());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      final LoadingScreen loading = LoadingScreen();
      if (state.isLoading) {
        loading.show(text: state.text ?? "loading....", context: context);
      } else {
        loading.hide();
      }
    }, builder: (context, state) {
      if (state is Needsverificattion) {
        return const VerifyEmail();
      } else if (state is LoggedinState) {
        return const NoteView();
      } else if (state is RestPasswordState) {
        return const ForgotPassword();
      } else if (state is LoggedOutState) {
        return const LoginScreen();
      } else if (state is RegesterState) {
        return const RegisterScreen();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
