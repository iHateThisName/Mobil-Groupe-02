import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobileapp_project/app/pages/welcome.dart';
import 'package:mobileapp_project/login_page.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'app/pages/landing_page.dart';
import 'package:mobileapp_project/app/pages/welcome.dart';


int? isViewed;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onWelcome');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToiletApp',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          backgroundColor: Colors.grey
        ),
        home: isViewed != 0 ? OnWelcome() : LoginPage(),
      ),
    );
  }
}