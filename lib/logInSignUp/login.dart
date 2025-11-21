import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/GoogleLoginIn/googleLoginIn.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';
import 'package:movie_app/logInSignUp/register.dart';
import 'package:movie_app/screens/navBar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var emailText = TextEditingController();
  var passText = TextEditingController();
  bool isHide = true;
  final _formKey = GlobalKey<FormState>();
  bool isNormalLoader = false;
  bool isGoogleLoader = false;

  Future<void> signIn(String email,String pass) async{
    setState(() {
      isNormalLoader = true;
    });
    String checkLogin = await FirebaseFunction()
        .signIn(email, pass);
    if(checkLogin=="success"){
      String userName = await FirebaseFunction().fetchUserName(email);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey.shade900,
              content: Text(
                "Welcome back $userName",
                style: TextStyle(color: Colors.white),
              )
          )
      );
      await SharePreference().setLogInState(true);
      await SharePreference().setUserName(userName);
      await SharePreference().setEmail(email);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavBar(),));
    }
    else if (checkLogin=="unsuccessful"){
      setState(() {
        isNormalLoader = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey.shade900,
              content: Text(
                "Please verify your email before login.",
                style: TextStyle(color: Colors.white),
              )
          )
      );
    }
    else{
      setState(() {
        isNormalLoader = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey.shade900,
              content: Text(
                checkLogin,
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
                        Text("Log In",style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
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
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Align(
                            alignment: Alignment.topRight,
                              child: Text("Forgot password?"),
                          ),
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                print(emailText.text);
                                print(passText.text);
                                await signIn(emailText.text, passText.text);
                              }
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets
                                  .symmetric(vertical: 10)),
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                            ),
                            child: isNormalLoader?CircularProgressIndicator(color:
                            Colors.white,):Text
                              ("Log In",style: TextStyle
                              (color:
                            Colors.white,fontSize: 16),),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text("or sign up with"),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              isGoogleLoader = true;
                            });
                            bool isLogged = await GoogleLoginIn().login(context);
                            setState(() {
                              isGoogleLoader = false;
                            });
                            if(isLogged){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavBar(),));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: isGoogleLoader?Center(
                              child: CircularProgressIndicator(color:
                              Colors.white,),
                            ):Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.google),
                                SizedBox(width: 10,),
                                Text("Continue with Google",style: TextStyle
                                  (fontSize: 16,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder:
                                (context) => Register(),));
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(text: "No account? "),
                                TextSpan(text: "Create one!",style: TextStyle
                                  (color:
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
          (isNormalLoader||isGoogleLoader)?Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
          ):Container(),
        ],
      ),
    );
  }
}
