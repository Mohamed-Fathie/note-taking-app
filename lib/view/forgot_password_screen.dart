import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freecodecamp/dialog/errordialog.dart';
import 'package:freecodecamp/dialog/generics/rest_dialog.dart';
import 'package:freecodecamp/services/auth/auth_excption.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is RestPasswordState) {
          if (state.exception is InvalidCredential) {
            await errordialog(context: context, error: 'invalid-email');
          } else if (state.exception is UserNotFound) {
            await errordialog(context: context, error: 'User-not-found');
          } else if (state.exception is GenericException) {
            await errordialog(context: context, error: 'hi something wrong');
          }
          if (state.emailissent) {
            _controller.clear();
            await restpassword(context: context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forgot password "),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: "enter you email here"),
                controller: _controller,
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(RestPassword(email: email));
                },
                child: const Text("send an email"),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const LoggoutEvent());
                },
                child: const Text("go to loggin"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
