import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {

  List<FAQ> data = [
    FAQ(question: "How do I edit my profile?", answer: "Go to Profile → Edit Profile and update your details."),
    FAQ(question: "How do I add movies or Tv show to watchlist?", answer: "Open any movie or Tv show → Tap the Bookmark icon."),
    FAQ(question: "How do I change my password?", answer: "Login → Forgot Password → Reset using your Email."),
    FAQ(question: "How do I delete a movie or Tv show from my watchlist?", answer: "Open your Watchlist → Tap the movie or Tv show → Press the Remove/Unbookmark icon."),
    FAQ(question: "Why am I not receiving notifications?", answer: "Make sure notification permissions are enabled in your device settings."),
    FAQ(
      question: "How do I log out of my account?",
      answer: "Go to Profile → Scroll down → Tap Logout to sign out safely.",
    ),
    FAQ(
      question: "How do I search for movies or TV shows?",
      answer: "Go to Search Tab → Type the movie or show name → Results will appear instantly.",
    ),
    FAQ(
      question: "How can I report a bug or problem?",
      answer: "Go to Help & Support → Contact Us and send the issue details to support.",
    ),
  ];

  Future<void> openEmailSupport() async{
    final Uri emailUrl = Uri.parse(
      "mailto:support@movieapp.com"
          "?subject=${Uri.encodeComponent('Movie App Support')}"
          "&body=${Uri.encodeComponent('Hello,\nI need help with...')}",
    );
    await launchUrl(emailUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Help & Support"),
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 5),
        child: ListView.separated(
          itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8,
                shadowColor: Colors.grey,
                child: ExpansionTile(
                  title: Text(data[index].question,style: TextStyle(fontSize:
                  16,fontWeight: FontWeight.bold),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(data[index].answer),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20,
              );
            },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          openEmailSupport();
        },
        backgroundColor: Colors.blue,
        label: Text("Contact us",style: TextStyle(fontWeight: FontWeight
            .bold,color: Colors.white),),
        icon: Icon(Icons.live_help,color: Colors.white,),
      ),
    );
  }
}

class FAQ{
  String question;
  String answer;
  FAQ({required this.question,required this.answer});
}