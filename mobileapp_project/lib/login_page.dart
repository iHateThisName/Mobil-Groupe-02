import 'package:mobileapp_project/custom_widgets/custom_elevatedbutton.dart';
import 'main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toilet App'),
        elevation: 2.0,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
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
          SizedBox(height: 10.0),
          SizedBox(
            height: 50,
            child: CustomElevatedButton(
            child: Text('Logg inn gjennom E-Mail'),
            color: Colors.deepOrangeAccent,
            borderRadius: 5,
            onPressed: () {},
          ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'eller',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 50,
            child: CustomElevatedButton(
              child: Text('Fortsett uten profil'),
              color: Colors.green,
              borderRadius: 5,
              onPressed: () {},
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