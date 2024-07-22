import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth/bloc/auth_state.dart';
import 'package:freecodecamp/view/verifyemail.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for AuthBloc
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

  Future<void> pumpVerifyEmailScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const VerifyEmail(),
        ),
      ),
    );
  }

  testWidgets('renders VerifyEmail screen and interacts with it',
      (tester) async {
    // Pump the VerifyEmail screen
    await pumpVerifyEmailScreen(tester);

    // Verify the presence of static texts
    expect(find.text('Verify Email  '), findsOneWidget);
    expect(find.text('verifiy your email by clicking on the button'),
        findsOneWidget);
    expect(find.text('click here'), findsOneWidget);
    expect(find.text('log in'), findsOneWidget);

    // Interact with the buttons and verify the corresponding events are added to the bloc
    await tester.tap(find.text('click here'));
    await tester.pumpAndSettle();
    verify(() => mockAuthBloc.add(const SendVerification())).called(1);

    await tester.tap(find.text('log in'));
    await tester.pumpAndSettle();
    verify(() => mockAuthBloc.add(const LoggoutEvent())).called(1);
  });
}
