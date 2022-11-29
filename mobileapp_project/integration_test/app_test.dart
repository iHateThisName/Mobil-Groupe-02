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
import 'package:mobileapp_project/app/pages/welcome.dart';


class MockAuth extends Mock implements AuthBase{}

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  MockAuth? mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

/*
  Future<void> pumpEmailSignIn(WidgetTester tester) async{
    print('mockAuth' + mockAuth.toString());
    await tester.pumpWidget(
      Provider<MockAuth>(
        create: (_) => mockAuth!,
        child: MaterialApp(
          home: Scaffold(body: EmailSignInStateful())
        ),
      ),
    );
  }

 */



  group('end-to-end app test', () {

    const email = 'test@test.com';
    const password = 'password';
    
    testWidgets('login test', (WidgetTester tester) async{
      app.main();
      await tester.pumpAndSettle();

      final nextButton = find.byType(TextButton);
      await tester.tap(nextButton);
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final emailLoginButton = find.byType(CustomElevatedButton).first;
      await tester.tap(emailLoginButton);
      await Future.delayed(Duration(seconds: 1));

      await tester.pumpAndSettle();

      final emailFormField = find.byType(TextField).first;
      expect(emailFormField, findsOneWidget);
      await tester.enterText(emailFormField, email);

      final passwordFormField = find.byType(TextField).last;
      expect(passwordFormField, findsOneWidget);
      await tester.enterText(passwordFormField, password);
      await Future.delayed(Duration(seconds: 1));

      await tester.pumpAndSettle();

      final signInButton = find.byType(CustomElevatedButton).first;
      await tester.tap(signInButton);
      await Future.delayed(Duration(seconds: 1));

      //expect(find.byKey(Key('profile_button')), findsOneWidget);

    },);
  });

}

