import 'package:flutter/material.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  var emailText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVerify = false;
  bool isLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  label: Text("Email"),
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    print(emailText.text);
                    await FirebaseFunction().sendResetLink(emailText.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.grey.shade900,
                            content: Text(
                              "Password reset email sent! Check your inbox.",
                              style: TextStyle(color: Colors.white),
                            )
                        )
                    );
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  // padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 40)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder
                    (borderRadius: BorderRadius.circular(10))),
                ),
                child: Text
                ("Send",style: TextStyle(color:
                Colors.white,fontSize: 16),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
