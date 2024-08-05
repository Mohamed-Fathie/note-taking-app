import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freecodecamp/dialog/errordialog.dart';
import 'package:freecodecamp/dialog/loading.dart';
import 'package:freecodecamp/helper/loading_screen.dart';
import 'package:freecodecamp/services/auth/auth_excption.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _pass;
  LoadingScreen? loading;
  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    loading = LoadingScreen();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoggedOutState && context.mounted) {
          if (state.excpetion is InvalidCredential) {
            await errordialog(context: context, error: 'invalid-email');
          } else if (state.excpetion is WrongPassword) {
            await errordialog(context: context, error: 'wrong-password');
          } else if (state.excpetion is UserNotFound) {
            await errordialog(context: context, error: 'User-not-found');
          } else if (state.excpetion is GenericException) {
            await errordialog(context: context, error: 'hi something wrong');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Login "),
        ),
        body: Column(children: [
          TextField(
            controller: _email,
            autocorrect: false,
            autofocus: true,
            enableSuggestions: false,
            decoration: const InputDecoration(
              hintText: "email",
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: _pass,
            autocorrect: false,
            autofocus: true,
            enableSuggestions: false,
            decoration: const InputDecoration(
              hintText: "pasword",
            ),
            obscureText: true,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final pass = _pass.text;
                context.read<AuthBloc>().add(LogginEvent(
                      email,
                      pass,
                    ));
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const ShouldRegister());
              },
              child: const Text("sign up?")),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(RestPassword(email: null));
              },
              child: const Text("forget your password?"))
        ]),
      ),
    );
  }
}
