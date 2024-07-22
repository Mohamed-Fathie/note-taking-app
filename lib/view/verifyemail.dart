import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Verify Email  "),
      ),
      body: Column(
        children: [
          const Text("verifiy your email by clicking on the button"),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const SendVerification());
            },
            child: const Text("click here"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const LoggoutEvent());
            },
            child: const Text("log in"),
          )
        ],
      ),
    );
  }
}
// That's a very good question.
// The actual Firebase auth provider that does the interfacing between our app and Firebase is a layer of abstraction so that our UI doesn't have to worry about
// authentication's details. The AuthProvider itself that wraps itself around the Firebase auth provider is a layer of abstraction that allows you to switch
// authentication providers in the future. In this course I show you how to use Firebase as a means of authentication.
// If you now want to add Google sign in authentication for instance,
// then you would write a new authentication layer and then perhaps plug that into the Auth provider and everything would work without a problem.