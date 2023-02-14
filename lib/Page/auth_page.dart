import 'package:firebase_setup/Widget/login_widget.dart';
import 'package:flutter/material.dart';

import '../Widget/signup_widget.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);
}
