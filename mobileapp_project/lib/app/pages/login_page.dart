import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/sign_in/email_sign_in_page.dart';
import 'package:mobileapp_project/custom_widgets/custom_elevatedbutton.dart';
import 'package:mobileapp_project/services/authentication.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toilet App'),
        elevation: 2.0,
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
          const Text(
            'Logg inn',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          CustomElevatedButton(
            color: Colors.blueGrey,
            borderRadius: 5,
            onPressed: null,
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('images/google-logo.png'),
                  const Text('Logg inn gjennom Google'),
                  Opacity(
                      opacity: 0, child: Image.asset('images/google-logo.png')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            color: Colors.indigo,
            borderRadius: 5,
            onPressed: null,
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('images/facebook-logo.png'),
                  const Text('Logg inn gjennom Facebook'),
                  Opacity(
                      opacity: 0,
                      child: Image.asset('images/facebook-logo.png')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 1.0),
          CustomElevatedButton(
            color: Colors.deepOrangeAccent,
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
            color: Colors.green,
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
        builder: (context) => EmailSignInPage(),
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
