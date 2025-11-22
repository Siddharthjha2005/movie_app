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
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whichPage();
  }

  Future<void> whichPage() async{
    final status = await SharePreference().getLoginStatus();
    Future.delayed(Duration(seconds: 1),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
      => (status==null||!status)?Login():NavBar(),));
    },);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset("assets/images/tmdb_logo.png",fit: BoxFit.cover,width: 100,height: 100,),
        ),
      ),
    );
  }
}
