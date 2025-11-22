import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';

class GoogleLoginIn {

  Future<bool> login(BuildContext context) async{
    try{
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount? user = await googleSignIn.authenticate();

      if(user==null){
        return false;
      }

      final email = user.email;
      final displayName = await FirebaseFunction().fetchUserName(email)
          ==""?user.displayName:await FirebaseFunction().fetchUserName(email);

      final GoogleSignInAuthentication userAuth = user.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: userAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      bool isEmailPresent = await FirebaseFunction().emailPresent(email);
      if(!isEmailPresent){
        int id = await FirebaseFunction().getId();
        if(id!=0){
          int newId = id+1;
          await FirebaseFunction()
              .saveUserDetails
            (profileImage: "",user: displayName!, doc: newId.toString(), email:
          email,password: "", mode: "Google",watchList: []);
        }
        else{
          await FirebaseFunction()
              .saveUserDetails
            (profileImage: "",user: displayName!, doc: "1", email:
          email,password: "", mode: "Google",watchList: []);
        }
      }
      await SharePreference().setLogInState(true);
      await SharePreference().setUserName(displayName!);
      await SharePreference().setEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey.shade900,
              content: Text(
                "Welcome back $displayName",
                style: TextStyle(color: Colors.white),
              )
          )
      );

      return FirebaseAuth.instance.currentUser != null;
    }
    catch (e) {
      print("Error: $e");
      return false;
    }
  }
}