import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/logInSignUp/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  var userText = TextEditingController();
  var emailText = TextEditingController();
  var passText = TextEditingController();
  bool isHide = true;
  final _formKey = GlobalKey<FormState>();
  bool? isAdded;
  bool isLoader = false;

  Future<void> signUp(String user,String email,String pass) async{
    setState(() {
      isLoader = true;
    });
    String userCreated = await FirebaseFunction()
        .signUp(email,
        pass);
    if(userCreated=="success"){
      int id = await FirebaseFunction().getId();
      if(id!=0){
        int newId = id+1;
        isAdded = await FirebaseFunction()
            .saveUserDetails
          (profileImage: "",user: user, doc: newId.toString(), email:
        email, password: pass, mode: "InApp",watchList: []);
      }
      else{
        isAdded = await FirebaseFunction()
            .saveUserDetails
          (profileImage: "",user: user, doc: "1", email:
        email, password: pass, mode: "InApp",watchList: []);
      }
      if(isAdded!){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey.shade900,
                content: Text(
                  "Registration successful. "
                      "Verification email has been sent.",
                  style: TextStyle(color: Colors.white),
                )
            )
        );
        userText.clear();
        emailText.clear();
        passText.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
      }
      else{
        setState(() {
          isLoader = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey.shade900,
                content: Text(
                  "Error in cloud storage",
                  style: TextStyle(color: Colors.white),
                )
            )
        );
      }
    }
    else{
      setState(() {
        isLoader = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey.shade900,
              content: Text(
                userCreated,
                style: TextStyle(color: Colors.white),
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/tmdb.png",
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height/2,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Create an account",style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
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
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: emailText,
                          validator: (value) {
                            if(!value!.contains("@")){
                              return "Email is invalid";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal:
                            20,vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: "Email address",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: passText,
                          validator: (value) {
                            if(value!.length<6){
                              return "Password should be at least 6 characters";
                            }
                            return null;
                          },
                          obscureText: isHide,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal:
                            20,vertical: 15),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isHide = !isHide;
                                  });
                                },
                                icon: isHide?
                                    Icon(Icons
                                    .visibility_off_outlined):Icon(Icons.visibility_outlined),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState!.validate()){
                                  print(emailText.text);
                                  print(passText.text);
                                  await signUp(userText.text, emailText.text,
                                      passText.text);
                                }
                              },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets
                                  .symmetric(vertical: 10)),
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                            ),
                              child: isLoader?CircularProgressIndicator
                                (color: Colors.white,)
                                  :Text("Sign Up",style: TextStyle
                                (color:
                              Colors.white,fontSize: 16),),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder:
                                (context) => Login(),));
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(text: "Already have an account? "),
                                TextSpan(text: "Login",style: TextStyle(color:
                                Colors.green)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          isLoader?Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ):Container(),
        ],
      ),
    );
  }
}
