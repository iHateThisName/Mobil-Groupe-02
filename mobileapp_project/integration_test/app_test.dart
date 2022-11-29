import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobileapp_project/app/sign_in/email_sign_in_stateful.dart';
import 'package:mobileapp_project/custom_widgets/custom_elevatedbutton.dart';
import 'package:mobileapp_project/main.dart' as app;
import 'package:mobileapp_project/services/authentication.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';


class MockAuth extends Mock implements AuthBase{}

void main(){
  MockAuth? mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignIn(WidgetTester tester) async{
    await tester.pumpWidget(
      Provider<MockAuth>(
        create: (_) => mockAuth!,
        child: MaterialApp(
          home: Scaffold(body: EmailSignInStateful())
        ),
      ),
    );
  }

  group('end-to-end app test', () {
    
    testWidgets('login', (WidgetTester tester) async{
      await pumpEmailSignIn(tester);

      final emailFormField = find.byType(TextField).first;
      expect(emailFormField, findsOneWidget);
      final passwordFormField = find.byType(TextField).last;
      expect(passwordFormField, findsOneWidget);

      await tester.enterText(emailFormField, 'test@test.com');
      await tester.enterText(passwordFormField, 'password');

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

    },);
  });

}

