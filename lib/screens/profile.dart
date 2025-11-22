import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';
import 'package:movie_app/logInSignUp/login.dart';
import 'package:movie_app/logInSignUp/register.dart';
import 'package:movie_app/pinataService/pinataService.dart';
import 'package:movie_app/profilePage/editProfile.dart';
import 'package:movie_app/screens/watchList.dart';

import 'navBar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<Data> data = [
    Data(title: 'Edit Profile', icon: Icons.person_outline),
    Data(title: 'My Watchlist', icon: Icons.bookmark_add_outlined),
    Data(title: 'Help & Support', icon: Icons.headset_mic_outlined),
    Data(title: 'Notification', icon: Icons.notifications_outlined),
    Data(title: 'Logout', icon: Icons.logout),
  ];

  String userName = "";
  String email = "";
  final ImagePicker _picker = ImagePicker();
  String profilePic = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocalData();
  }

  Future<void> fetchLocalData() async{
    String? user = await SharePreference().getUserName();
    String? emailId = await SharePreference().getEmail();
    if(user!=null && emailId!=null){
      setState(() {
        userName = user;
        email = emailId;
      });
    }
    String? profile = await FirebaseFunction().fetchProfilePic(email);
    setState(() {
      profilePic = profile;
    });
  }

  Future<void> pickImage() async{
    XFile? pickImg = await _picker.pickImage(source: ImageSource.gallery);
    if(pickImg!=null){
      File selectImage = File(pickImg.path);
      String filePath = selectImage.path;
      final cid = await PinataService().uploadImage(filePath);
      var downloadUrl = "https://gateway.pinata.cloud/ipfs/$cid";
      await FirebaseFunction().addProfilePic(email, downloadUrl);
      setState(() {
        profilePic = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        // leading: Container(
        //   padding: EdgeInsets.all(5),
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: Colors.white10,
        //   ),
        //   child: Icon(
        //     Icons.keyboard_arrow_left,
        //     size: 30,
        //   ),
        // ),
        title: Text("Profile"),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white10,
            ),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(right: 10,left: 10),
        child: Column(
          children: [
            SizedBox(height: 50,),
            GestureDetector(
              onTap: (){
                pickImage();
              },
              child: Stack(
                children: [
                  profilePic.isNotEmpty?CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profilePic),
                  ):CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade900,
                    child: Icon(Icons.image_not_supported),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit_outlined),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Text(userName,style: TextStyle(fontSize: 22,fontWeight:
            FontWeight.bold),),
            SizedBox(height: 5,),
            Text(email,style: TextStyle(color: Colors.grey),),
            SizedBox(height: 10,),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade900,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(Icons.edit_outlined),
            //       SizedBox(width: 5,),
            //       Text("Edit Profile"),
            //     ],
            //   ),
            // ),
            SizedBox(height: 25,),
            // Text("Inventories",style: TextStyle(fontSize: 16,fontWeight:
            // FontWeight.bold),),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () async{
                        if(data[index].title=="Edit Profile"){
                          userName = await Navigator.push(context,
                              MaterialPageRoute(builder:
                              (context) => EditProfile(),));
                          setState(() {

                          });
                        }
                        else if(data[index].title=="My Watchlist"){
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NavBar(pageNo: 2,),));
                        }
                        else if(data[index].title=="Help & Support"){

                        }
                        else if(data[index].title=="Notification"){

                        }
                        else if(data[index].title=="Logout"){
                          await FirebaseAuth.instance.signOut();
                          await SharePreference().setLogInState(false);
                          await SharePreference().allClear();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login(),));
                        }
                      },
                      leading: Icon(data[index].icon),
                      title: Text(data[index].title),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Data{
  String title;
  IconData icon;
  Data({required this.title,required this.icon});
}
