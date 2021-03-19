import 'package:awesome_words/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        navigateAfterSeconds: HomeScreen(),
        seconds: 8,
        photoSize: 150,
        image: Image.asset("assets/images/Black logo - no background.png"),  
            
    );
  }
}