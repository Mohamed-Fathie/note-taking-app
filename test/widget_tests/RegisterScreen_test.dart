import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/dialog/errordialog.dart';
import 'package:freecodecamp/services/auth/auth_excption.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';
import 'package:freecodecamp/view/register_view.dart';
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

  Future<void> pumpRegisterScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const RegisterScreen(),
        ),
      ),
    );
  }

  testWidgets('shows error dialog for weak password', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([
        RegesterState(
          WeekPassword(),
        ),
      ]),
    );
    when(() => mockAuthBloc.state).thenReturn(RegesterState(
      WeekPassword(),
    ));

    await pumpRegisterScreen(tester);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('weak-password'), findsOneWidget);
  });

  testWidgets('shows error dialog for email already in use', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([
        RegesterState(
          Emailalreadyinuse(),
        ),
      ]),
    );
    when(() => mockAuthBloc.state).thenReturn(RegesterState(
      Emailalreadyinuse(),
    ));

    await pumpRegisterScreen(tester);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('email-already-in-use'), findsOneWidget);
  });

  testWidgets('shows error dialog for invalid email', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([
        RegesterState(InvalidEmail()),
      ]),
    );
    when(() => mockAuthBloc.state).thenReturn(RegesterState(
      InvalidEmail(),
    ));

    await pumpRegisterScreen(tester);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('invalid-email'), findsOneWidget);
  });

  testWidgets('shows error dialog for empty fields', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([
        RegesterState(
          Emptyfields(),
        ),
      ]),
    );
    when(() => mockAuthBloc.state).thenReturn(RegesterState(Emptyfields()));

    await pumpRegisterScreen(tester);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('password or email is empty'), findsOneWidget);
  });
}
