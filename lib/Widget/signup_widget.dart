import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_setup/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              FlutterLogo(size: 120),
              SizedBox(height: 20),
              Text(
                'Welcome Back \n Congratulations on Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a Valid Email'
                        : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Password'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter minimum 6 characters'
                    : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter minimum 6 characters'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: signUp,
                icon: Icon(
                  Icons.arrow_forward,
                  size: 32,
                ),
                label: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    text: "Already Have an Account ?  ",
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Log In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      );
  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
