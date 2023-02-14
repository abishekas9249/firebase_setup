import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Signed In as",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                user.email!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: Icon(Icons.arrow_back),
                label: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
