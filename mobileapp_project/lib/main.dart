import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobileapp_project/app/pages/mappage.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app/pages/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'ToiletApp',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          backgroundColor: Colors.grey
        ),
        home: MapPage(),
      ),
    );
  }
}