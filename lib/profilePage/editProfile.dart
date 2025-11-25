import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  var userText = TextEditingController();
  var emailText = TextEditingController();
  var passText = TextEditingController();
  bool isHide = true;
  bool isLoader = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocalData();
  }

  Future<void> fetchLocalData() async{
    final emailId = await SharePreference().getEmail();
    final user = await SharePreference().getUserName();
    final pass = await SharePreference().getPass();
    if(emailId!=null && user!=null){
      setState(() {
        emailText.text = emailId;
        userText.text = user;
        passText.text = pass ?? "";
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
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context,userText.text);
            },
            icon: Icon(Icons.arrow_back_outlined),
        ),
        title: Text("Edit profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 200,),
                TextFormField(
                  controller: userText,
                  validator: (value) {
                    if(value!.length<3){
                      return "Name must be at least 3 characters long.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal:
                    20,vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: "Enter username",
                    hintStyle: TextStyle(color: Colors.white),
                    label: Text("Username"),
                  ),
                ),
                SizedBox(height: 40,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: TextFormField(
                    controller: emailText,
                    validator: (value) {
                      if(!value!.contains("@")){
                        return "Email is invalid";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: false,
                      contentPadding: EdgeInsets.symmetric(horizontal:
                      20,vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Email address",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                // passText.text!=""?TextFormField(
                //   controller: passText,
                //   validator: (value) {
                //     if(value!.length<6){
                //       return "Password should be at least 6 characters";
                //     }
                //     return null;
                //   },
                //   obscureText: isHide,
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(horizontal:
                //     20,vertical: 15),
                //     suffixIcon: IconButton(
                //       onPressed: () {
                //         setState(() {
                //           isHide = !isHide;
                //         });
                //       },
                //       icon: isHide?
                //       Icon(Icons
                //           .visibility_off_outlined):Icon(Icons.visibility_outlined),
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     hintText: "Password",
                //     hintStyle: TextStyle(color: Colors.white),
                //     label: Text("Password"),
                //   ),
                // ):Container(),
                // passText.text!=""?SizedBox(height: 40,):Container(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          isLoader = true;
                        });
                        await FirebaseFunction().updateUserName(emailText
                            .text, userText.text);
                        await SharePreference().removeUserName();
                        await SharePreference().removePass();
                        await SharePreference().setUserName(userText.text);
                        await SharePreference().setPass(passText.text);
                        setState(() {
                          isLoader = false;
                        });
                        Fluttertoast.showToast(msg: "Update Successful");
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets
                          .symmetric(vertical: 10)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: isLoader?CircularProgressIndicator
                      (color: Colors.white,)
                        :Text("Save",style: TextStyle
                      (color:
                    Colors.white,fontSize: 16),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
