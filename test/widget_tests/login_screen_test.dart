import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/dialog/errordialog.dart';
import 'package:freecodecamp/dialog/loading.dart';
import 'package:freecodecamp/services/auth/auth_excption.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';
import 'package:freecodecamp/view/loginscreen.dart';

import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  testWidgets('shows loading dialog when state is loading', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream<AuthState>.fromIterable([
        LoggedOutState(
          isLoading: true,
          excpetion: null,
        ),
      ]),
      initialState: LoggedOutState(
        isLoading: true,
        excpetion: null,
      ),
    );

    await pumpLoginScreen(tester);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('loading...'), findsOneWidget);
  });

  testWidgets('shows loading dialog when state is loading', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream<AuthState>.fromIterable([
        LoggedOutState(
          isLoading: true,
          excpetion: null,
        ),
      ]),
      initialState: LoggedOutState(isLoading: true, excpetion: null),
    );

    await pumpLoginScreen(tester);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('loading...'), findsOneWidget);
  });

  testWidgets('shows error dialog when state has an exception', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream<AuthState>.fromIterable([
        LoggedOutState(isLoading: false, excpetion: InvalidCredential()),
      ]),
      initialState:
          LoggedOutState(isLoading: false, excpetion: InvalidCredential()),
    );

    await pumpLoginScreen(tester);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('invalid-email'), findsOneWidget);
  });
}
