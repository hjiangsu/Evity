import 'package:flutter/material.dart';

import 'package:Evity/screens/welcome_screen/WelcomeScreen.dart';

void main() {
  runApp(Evity());
}

// Root Application
class Evity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evity',
      home: WelcomeScreen(),
    );
  }
}
