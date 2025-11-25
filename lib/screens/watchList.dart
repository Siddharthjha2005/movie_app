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
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAll("all");
  }

  Future<void> fetchAll(String type) async{
    if(isLoading){
      return;
    }
    setState(() {
      isLoading = true;
      watchListData.clear();
    });

    final email = await SharePreference().getEmail();
    final watch = await FirebaseFunction().fetchWatchList(email!,type);

    List temp = [];
    for(var data in watch){
      final watchList = await ApiFunction().fetchData(data['MediaType'], data['MovieId']);
      temp.add(watchList);
    }

    setState(() {
      watchListData = temp;
      isLoading = false;
    });
  }

  Widget displayWatchList(List data) {
    return GridView.builder(
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
        automaticallyImplyLeading: false,
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: isLoading?null:(){
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
                    child: Text("All",style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: isLoading?null:(){
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
                    child: Text("Movie",style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: isLoading?null:(){
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
                    child: Text("Tv",style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: isLoading?Shimmer(
                color: Colors.white,
                child: GridView.builder(
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
              ):(watchListData.isEmpty && isAll)
                  ? Center(
                child: Text(
                  "No movies or TV shows added to Watchlist",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ):(watchListData.isEmpty && isMovie)
                  ? Center(
                child: Text(
                  "No movies added to Watchlist",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ):(watchListData.isEmpty && isTv)
                  ? Center(
                child: Text(
                  "No TV shows added to Watchlist",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ):displayWatchList(watchListData),
            ),
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }
}
