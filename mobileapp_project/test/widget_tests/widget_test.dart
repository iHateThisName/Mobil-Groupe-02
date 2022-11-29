import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp_project/main.dart';
import 'dart:ui';


void main() {
  testWidgets('Widget tests', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Expect to find one widget with type column
    var column = find.byType(Column);
    expect(column, findsOneWidget);

    // Expects to find several Text widgets
    var text = find.byType(Text);
    expect(text, findsWidgets);

    //Expects to find several ElevatedButton widgets
    var elevatedButton = find.byType(ElevatedButton);
    expect(elevatedButton, findsWidgets);

    // Expects to find one specific button with the input text
    var specificButton = find.text('Logg inn gjennom E-Mail');
    expect(specificButton, findsOneWidget);

    var specificButton2 = find.text('Fortsett uten profil');
    expect(specificButton2, findsOneWidget);

    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'test');
    expect(find.text('test'), findsOneWidget);

  });

}