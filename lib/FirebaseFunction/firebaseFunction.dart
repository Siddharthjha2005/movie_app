import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseFunction {

  String collName = "UserDetails";

  Future<String> signUp(String email,String password) async{
    try{
      UserCredential  userCredential= await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email:
      email, password: password);
      await userCredential.user!.sendEmailVerification();
      return "success";
    }
    on FirebaseAuthException catch (e){
      if(e.code=="invalid-email"){
        return "Invalid email format";
      }
      else if (e.code == 'email-already-in-use') {
        return "Email already exists";
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      }
      else{
        return "Something went wrong";
      }
    }
  }

  Future<String> signIn(String email,String password) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if(user!=null && user.emailVerified){
        return "success";
      }
      else{
        return "unsuccessful";
      }
    }
    on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found') {
        return "User needs to register";
      } else if (e.code == 'wrong-password') {
        return "Invalid password";
      }
      else{
        return "Something went wrong";
      }
    }
  }

  Future<bool> saveUserDetails({String? profileImage,required String user,
    required String doc,
    required String email,String?
  password, required String mode,List? watchList}) async{
    try{
      await FirebaseFirestore.instance.collection(collName)
          .doc(doc)
          .set({
        "ProfileImage":profileImage,
        "UserName":user,
        "Email":email,
        "Password":password,
        "SignUpMode":mode,
        "WatchList":[],
      });
      return true;
    }
    catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<int> getId() async{
    int id = 0;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collName);
    QuerySnapshot snapshot = await collectionReference.get();
    for(var doc in snapshot.docs){
      if(id<int.parse(doc.id)){
        id = int.parse(doc.id);
      }
    }
    return id;
  }

  Future<String> fetchUserName(String email) async{
    String user = "";
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collName);
    QuerySnapshot snapshot = await collectionReference.get();
    for(var doc in snapshot.docs){
      final data = doc.data() as Map<String,dynamic>;
      if(email==data['Email']){
        user = data['UserName'];
      }
    }
    return user;
  }

  Future<bool> emailPresent(String email) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collName);
    QuerySnapshot snapshot = await collectionReference.get();
    for(var doc in snapshot.docs){
      final data = doc.data() as Map<String,dynamic>;
      if(email==data['Email']){
        return true;
      }
    }
    return false;
  }

}