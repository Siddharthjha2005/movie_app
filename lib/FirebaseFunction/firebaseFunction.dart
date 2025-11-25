import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';

import '../movieApi/apiFunction.dart';

class FirebaseFunction {

  String collName = "UserDetails";

  Future<bool> sendResetLink(String email) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    }
    catch (e){
      print("Error: $e");
      return false;
    }

  }

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

  Future<void> addAndRemoveToWatchList(String watchList,String email,int
  movieId, String
  mode)
  async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection
        (collName).where("Email",isEqualTo: email).get();
      if(snapshot.docs.isNotEmpty){
        String id = snapshot.docs.first.id;
        if(watchList=="add"){
          await FirebaseFirestore.instance.collection(collName)
              .doc(id)
              .update({
            "WatchList":FieldValue.arrayUnion([
              {
                "MovieId":movieId,
                "MediaType":mode,
              }
            ]),
          });
        }
        else if(watchList=="remove"){
          await FirebaseFirestore.instance.collection(collName)
              .doc(id)
              .update({
            "WatchList":FieldValue.arrayRemove([
              {
                "MovieId":movieId,
                "MediaType":mode,
              }
            ]),
          });
        }

      }
    }
    catch (e){
      print("Error: $e");
    }
  }

  Future<void> addProfilePic(String email,String file) async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection
        (collName).where("Email",isEqualTo: email).get();
      if(snapshot.docs.isNotEmpty){
        String id = snapshot.docs.first.id;
        await FirebaseFirestore.instance.collection(collName)
            .doc(id)
        .update({
          "ProfileImage":file,
        });
      }
    }
    catch (e) {
      print("Error: $e");
    }
  }

  Future<String> fetchProfilePic(String email) async{
    String file = "";
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection
        (collName).where("Email",isEqualTo: email).get();
      if(snapshot.docs.isNotEmpty){
        String id = snapshot.docs.first.id;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection
          (collName)
            .doc(id)
            .get();
        if(userDoc.exists){
          if(userDoc['ProfileImage'].toString().isNotEmpty){
            file = userDoc['ProfileImage'];
          }
        }
      }
      return file;
    }
    catch (e) {
      print("Error: $e");
      return file;
    }
  }

  Future<void> updateUserName(String email,String user) async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection
        (collName).where("Email",isEqualTo: email).get();
      if(snapshot.docs.isNotEmpty){
        String id = snapshot.docs.first.id;
        await FirebaseFirestore.instance.collection
          (collName).doc(id).update({
          "UserName":user,
        });
      }
    }
    catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateUserPassword(String email,String pass) async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection
        (collName).where("Email",isEqualTo: email).get();
      if(snapshot.docs.isNotEmpty){
        String id = snapshot.docs.first.id;
        await FirebaseFirestore.instance.collection
          (collName).doc(id).update({
          "Password":pass,
        });
      }
    }
    catch (e) {
      print("Error: $e");
    }
  }

  Future<bool> matchWatchList(String email,int movieId) async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection
        (collName).where("Email",isEqualTo: email).get();
      if(snapshot.docs.isNotEmpty){
        String id = snapshot.docs.first.id;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(collName).doc(id).get();
        if(userDoc.exists){
          List watchList = userDoc['WatchList'] ?? [];
          if(watchList.isNotEmpty){
            for(var doc in watchList){
              if(doc['MovieId']==movieId){
                return true;
              }
            }
          }
        }
      }
      return false;
    }
    catch (e){
      print("Error: $e");
      return false;
    }
  }

  Future<List> fetchWatchList(String email,String type) async{
    List data = [];
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection
        (collName).where("Email",isEqualTo: email).get();
      if(snapshot.docs.isNotEmpty){
        String id = snapshot.docs.first.id;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(collName).doc(id).get();
        if(userDoc.exists){
          List watchList = userDoc['WatchList'] ?? [];
          if(watchList.isNotEmpty){
            if(type=="all"){
              data = watchList;
            }
            else if(type=="movie"){
              for(var doc in watchList){
                if(doc['MediaType']==type){
                  data.add(doc);
                }
              }
            }
            else if(type=="tv"){
              for(var doc in watchList){
                if(doc['MediaType']==type){
                  data.add(doc);
                }
              }
            }
          }
        }
      }
      return data;
    }
    catch (e){
      print("Error: $e");
      return data;
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