import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/ShareApp/shareAppLink.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';
import 'package:movie_app/logInSignUp/login.dart';
import 'package:movie_app/logInSignUp/register.dart';
import 'package:movie_app/pinataService/pinataService.dart';
import 'package:movie_app/profilePage/editProfile.dart';
import 'package:movie_app/profilePage/helpSupport.dart';
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
  bool isLoader = false;

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
      profilePic = profile ?? "";
    });
  }

  Future<void> pickImage() async{
    XFile? pickImg = await _picker.pickImage(source: ImageSource.gallery);
    if(pickImg!=null){
      setState(() {
        isLoader = true;
      });
      File selectImage = File(pickImg.path);
      String filePath = selectImage.path;
      final cid = await PinataService().uploadImage(filePath);
      var downloadUrl = "https://gateway.pinata.cloud/ipfs/$cid";
      await FirebaseFunction().addProfilePic(email, downloadUrl);
      setState(() {
        profilePic = downloadUrl;
        isLoader = false;
      });
    }
  }

  Future _showAlert() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // contentPadding: EdgeInsets.zero,
            title: Center(child: Text("Are you sure?",style: TextStyle
              (fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("This action cannot be undone",style: TextStyle(color:
                Colors.grey),),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors
                              .white24),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder
                            (borderRadius: BorderRadius.circular(10))),
                        ),
                          child: Text("No",style: TextStyle(color: Colors
                              .white,fontWeight: FontWeight.bold,fontSize:
                          16),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async{
                            await FirebaseAuth.instance.signOut();
                            await SharePreference().setLogInState(false);
                            await SharePreference().allClear();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => Login(),));
                          },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder
                            (borderRadius: BorderRadius.circular(10))),
                        ),
                          child: Text("Yes",style: TextStyle(color: Colors
                              .white,fontWeight: FontWeight.bold,fontSize:
                          16),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 5),
        actions: [
          IconButton(
              onPressed: () async{
                bool isShare = await ShareAppLink().shareApp();
                if(isShare){
                  Fluttertoast.showToast(msg: "Thanks for sharing our app!");
                }
              },
              icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(right: 10,left: 10),
        child: ListView(
          children: [
            SizedBox(height: 50,),
            GestureDetector(
              onTap:isLoader?null:(){
                pickImage();
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: isLoader?Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        shape: BoxShape.circle,
                      ),
                        child: Center(child: CircularProgressIndicator(color: Colors.white,)))
                        :CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade900,
                      backgroundImage: profilePic.isNotEmpty?NetworkImage
                        (profilePic):null,
                      child: profilePic.isEmpty?Icon(Icons
                          .image_not_supported,size: 35,):null,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: MediaQuery.of(context).size.width/2 - 80,
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
            Align(
              alignment: Alignment.center,
              child: Text(userName,style: TextStyle(fontSize: 24,fontWeight:
              FontWeight.bold),),
            ),
            SizedBox(height: 5,),
            Align(
              alignment: Alignment.center,
                child: Text(email,style: TextStyle(color: Colors.grey,
                    fontSize: 16),),
            ),
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
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  shadowColor: Colors.white70,
                  child: ListTile(
                    onTap: () async{
                      if(data[index].title=="Edit Profile"){
                        final newName = await Navigator.push(context,
                            MaterialPageRoute(builder:
                            (context) => EditProfile(),));
                        if(newName!=null){
                          setState(() {
                            userName = newName;
                          });
                        }
                      }
                      else if(data[index].title=="My Watchlist"){
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NavBar(pageNo: 2,),));
                      }
                      else if(data[index].title=="Help & Support"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupport(),));
                      }
                      else if(data[index].title=="Notification"){

                      }
                      else if(data[index].title=="Logout"){
                        _showAlert();
                      }
                    },
                    leading: Icon(data[index].icon,color: data[index]
                        .title=="Logout"?Colors.red:Colors.grey,),
                    title: Text(data[index].title,style: TextStyle
                      (fontWeight: FontWeight.bold,color: data[index]
                        .title=="Logout"?Colors.red:Colors.white),),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined,color: Colors.grey,),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
            ),
            SizedBox(height: 100,),
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
