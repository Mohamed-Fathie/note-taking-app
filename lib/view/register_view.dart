import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freecodecamp/dialog/errordialog.dart';
import 'package:freecodecamp/services/auth/auth_excption.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _email;
  late final TextEditingController _pass;
  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
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
        if (state is RegesterState) {
          if (state.exception is WeekPassword) {
            await errordialog(context: context, error: 'weak-password');
          } else if (state.exception is Emailalreadyinuse) {
            await errordialog(context: context, error: 'email-already-in-use');
          } else if (state.exception is InvalidEmail) {
            await errordialog(context: context, error: 'invalid-email');
          } else if (state.exception is Emptyfields) {
            await errordialog(
                context: context, error: "password or email is empty");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Register "),
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
                context.read<AuthBloc>().add(RegesteringEvent(
                      email,
                      pass,
                    ));
              },
              child: const Text('register')),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LoggoutEvent());
              },
              child: const Text('Log in?'))
        ]),
      ),
    );
  }
}
