import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/pages/sign_in/email_sign_in_page.dart';
import 'package:mobileapp_project/custom_widgets/custom_elevatedbutton.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:provider/provider.dart';


/// A class that represents our log in page.

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.blue.withOpacity(0.5),
        backgroundColor: Colors.black.withBlue(20), //Colors.black.withOpacity(0.85),
        title: Image.asset('images/my-image (1).png',),
        centerTitle: true,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Image(image: AssetImage('images/hvor-kan-jeg-drite-logo.png')),
          const SizedBox(height: 10),
          const Text(
            'Logg inn',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          const SizedBox(height: 10),
          const SizedBox(height: 1.0),
          CustomElevatedButton(
            color: Colors.blue.withOpacity(0.7),
            borderRadius: 5,
            onPressed: () => _logInWithEmail(context),
            child: const SizedBox(
              child: Text('Logg inn gjennom E-Mail'),
            ),
          ),
          const Text(
            'eller',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1.0),
          CustomElevatedButton(
            color: Colors.black.withBlue(20),
            borderRadius: 5,
            onPressed: () => _logInAnonymously(context),
            child: const SizedBox(
              child: Text('Fortsett uten profil'),
            ),
          ),
        ],
      ),
    );
  }



  void logInWithGoogle() {
    // TODO: Auth with Google
  }
  void logInWithFacebook() {
    // TODO: Auth with Google
  }
  void _logInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const EmailSignInPage(),
      ),
    );
  }

  Future<void> _logInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }
}
