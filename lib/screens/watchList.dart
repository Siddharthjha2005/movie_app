import 'package:flutter/material.dart';
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';
import 'package:movie_app/movieApi/apiFunction.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../details/Details.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {

  bool isAll = true;
  bool isMovie = false;
  bool isTv = false;
  List watchListData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAll("all");
  }

  Future<void> fetchAll(String type) async{
    final email = await SharePreference().getEmail();
    final watch = await FirebaseFunction().fetchWatchList(email!,type);
    for(var data in watch){
      final watchList = await ApiFunction().fetchData(data['MediaType'], data['MovieId']);
      setState(() {
        watchListData.add(watchList);
      });
    }
  }

  Widget displayWatchList(List data) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async{
            bool isWatch = await Navigator.push(context, MaterialPageRoute(builder:
                (context) => Details(data:
            data[index][0], mode: data[index][0]
                .mediaType)
              ,));
            if(!isWatch) {
              setState(() {
                watchListData.clear();
                if(isAll){
                  fetchAll("all");
                }
                else if(isMovie){
                  fetchAll("movie");
                }
                else if(isTv){
                  fetchAll("tv");
                }
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(data[index][0]
                .posterImage,
              fit: BoxFit.cover,),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        watchListData.clear();
                        isAll = true;
                        isMovie = false;
                        isTv = false;
                        fetchAll("all");
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      decoration: BoxDecoration(
                        color: isAll?Colors.blue:Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("All",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        watchListData.clear();
                        isAll = false;
                        isMovie = true;
                        isTv = false;
                        fetchAll("movie");
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      decoration: BoxDecoration(
                        color: isMovie?Colors.blue:Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Movie",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        watchListData.clear();
                        isAll = false;
                        isMovie = false;
                        isTv = true;
                        fetchAll("tv");
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      decoration: BoxDecoration(
                        color: isTv?Colors.blue:Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Tv",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              watchListData.isEmpty?Shimmer(
                color: Colors.white,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey.shade900,
                      );
                    },
                ),
              ):displayWatchList(watchListData),
            ],
          ),
        ),
      ),
    );
  }
}
