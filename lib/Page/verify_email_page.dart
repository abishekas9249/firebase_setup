import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_setup/Page/home_page.dart';
import 'package:firebase_setup/utils.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool resendEmail = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => resendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => resendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text("Verify Email"),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "A verification email has been sent to Your Email. ",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: resendEmail ? sendVerificationEmail : null,
                  icon: Icon(Icons.email, size: 32),
                  label: Text(
                    "Resend Email",
                    style: TextStyle(fontSize: 24),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                ),
                TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        );
}
