import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobileapp_project/main.dart' as app;

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end app test', () {
    final emailFormField = find.byType(TextFormField).first;
    final passwordFormField = find.byType(TextFormField).last;
    final loginButton = find.byType(ElevatedButton).first;
    
    testWidgets('login is working', (tester) async{
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(emailFormField, 'test@test.com');
      await tester.enterText(passwordFormField, 'password');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();


      final firstMarker = find.byType(Marker).first;
      expect(tester.getSemantics(firstMarker), matchesSemantics(
      hasTapAction: true,
      isEnabled: true,
      ),);

    },
    );
    
    
    
  });
}

