import 'package:mobileapp_project/custom_widgets/custom_elevatedbutton.dart';
import 'package:mobileapp_project/sign_in/sign_in_anonymously_code.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget with Anonymous {
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
      padding: EdgeInsets.all(16),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Logg inn',
          textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.0),
          SizedBox(
            height: 50,
            child: CustomElevatedButton(
            color: Colors.blueGrey,
            borderRadius: 5,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset('images/google-logo.png'),
                Text('Logg inn gjennom Google'),
                Opacity(
                    opacity: 0,
                    child: Image.asset('images/google-logo.png')),
              ],
            ) ,
          ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: CustomElevatedButton(
            color: Colors.indigo,
            borderRadius: 5,
            onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('images/facebook-logo.png'),
                  Text('Logg inn gjennom Facebook'),
                  Opacity(
                      opacity: 0,
                      child: Image.asset('images/facebook-logo.png')),
                ],
              ) ,
          ),
          ),
          SizedBox(height: 1.0),
          SizedBox(
            child: CustomElevatedButton(
            child: Text('Logg inn gjennom E-Mail'),
            color: Colors.deepOrangeAccent,
            borderRadius: 5,
            onPressed: () {},
          ),
          ),
          Text(
            'eller',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.0),
          SizedBox(
            child: CustomElevatedButton(
              child: Text('Fortsett uten profil'),
              color: Colors.green,
              borderRadius: 5,
              onPressed: () => signInAnonymously(context),
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
  void logInWithEmail() {
    // TODO: Auth with Google
  }

  }