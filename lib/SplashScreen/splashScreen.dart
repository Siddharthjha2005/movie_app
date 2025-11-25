import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/logInSignUp/login.dart';

import '../SharedPreference/sharePreference.dart';
import '../screens/navBar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isLogin = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whichPage();
  }

  Future<void> whichPage() async{
    final status = await SharePreference().getLoginStatus() ?? false;
    setState(() {
      isLogin = status;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1,
      backgroundColor: Colors.black,
      splash: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset("assets/images/tmdb_logo.png"),
        ),
      ),
      nextScreen: isLogin?NavBar():Login(),
    );
  }
}
