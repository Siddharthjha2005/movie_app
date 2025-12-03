import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie_app/screens/home.dart';
import 'package:movie_app/screens/profile.dart';
import 'package:movie_app/screens/search.dart';
import 'package:movie_app/screens/watchList.dart';

class NavBar extends StatefulWidget {
  int? pageNo;
  NavBar({super.key,this.pageNo});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  int pageIndex = 0;
  List page = [Home(),Search(),WatchList(),Profile()];

  List<IconData> icons = [Icons.home_outlined,Icons.search_outlined,Icons
      .bookmark_add_outlined,Icons.account_circle_outlined];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.pageNo!=null){
      setState(() {
        pageIndex = widget.pageNo!;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          page[pageIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20,right: 20,left: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 15,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(icons.length, (index){
                        final bool isSelected = pageIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              pageIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            curve: Curves.easeOutBack,
                            padding: EdgeInsets.all(10),
                            duration: Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected?Colors.blue:Colors.white10,
                            ),
                            child: Icon(
                              icons[index],
                              size: 30,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
