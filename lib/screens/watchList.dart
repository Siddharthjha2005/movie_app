import 'package:flutter/material.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            // Container(
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
            SizedBox(width: 5,),
            Text("Watchlist"),
            Spacer(),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white10,
              ),
              child: Icon(Icons.notifications_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
