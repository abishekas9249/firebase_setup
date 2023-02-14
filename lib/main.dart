import 'package:firebase_setup/Page/verify_email_page.dart';
import 'package:firebase_setup/Widget/login_widget.dart';
import 'package:firebase_setup/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_setup/Page/home_page.dart';

import 'Page/auth_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static final String title = 'Setup Firebase';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        debugShowCheckedModeBanner: false,
        title: title,
        navigatorKey: navigatorKey,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              return VerifyEmailPage();
            } else {
              return AuthPage();
            }
          },
        ),
      );
}
