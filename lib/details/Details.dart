import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/FirebaseFunction/firebaseFunction.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';
import 'package:movie_app/movieApi/apiFunction.dart';
import 'package:movie_app/videoPlayer/watchNow.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  final data;
  final mode;
  const Details({super.key,required this.data,required this.mode});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  List genres = [];
  List character = [];
  List similarData = [];
  String trailerKey = "";
  // Uri ytLink = Uri.parse("");
  bool isWatchList = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWatchList();
    fetchAll();
  }

  Future<void> fetchAll() async{
    final genre = await ApiFunction().fetchGenre(widget.mode,widget.data.id);
    final cast = await ApiFunction().fetchCast(widget.mode,widget.data.id);
    final similar = await ApiFunction().fetchSimilar(widget.mode,widget.data.id);
    final key = await ApiFunction().fetchTrailerKey(widget.mode, widget.data
        .id,0,0);
    setState(() {
      genres = genre;
      character = cast;
      similarData = similar;
      trailerKey = key;
    });
  }

  Future<void> fetchWatchList() async{
    final email = await SharePreference().getEmail();
    final isWatch = await FirebaseFunction().matchWatchList(email!,
        widget.data.id) ;
    setState(() {
      isWatchList = isWatch;
    });
  }

  Future<void> addAndRemoveToWatchList(String watchList) async{
    final email = await SharePreference().getEmail();
    await FirebaseFunction().addAndRemoveToWatchList(watchList,email!, widget.data.id, widget.mode);
  }

  Widget castCharacter() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: character.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              width: 240,
              color: Colors.white10,
              padding: EdgeInsets.only(left: 15,right: 5),
              child: Row(
                children: [
                  character[index].profileImage.toString()
                      .isEmpty?Icon(Icons.image_not_supported_outlined):ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(character[index]
                        .profileImage,height: 50,),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(character[index].name,style:
                        TextStyle(fontWeight: FontWeight.bold,),),
                        Text(character[index].character,style:
                        TextStyle(color: Colors.grey,fontSize:
                        12),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget similar() {
    return similarData.isEmpty?Center(child: CircularProgressIndicator())
        :SizedBox(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: similarData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  Details(data: similarData[index],mode: widget.mode,)
                ,));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  similarData[index].posterImage,
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.data.backImage,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height/1.8,
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context,isWatchList);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isWatchList = !isWatchList;
                        if(isWatchList){
                          Fluttertoast.showToast(msg: "Added to your "
                              "watchlist!");
                          addAndRemoveToWatchList("add");
                        }
                        else{
                          Fluttertoast.showToast(msg: "Remove from your "
                              "watchlist.",);
                          addAndRemoveToWatchList("remove");
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: isWatchList?Icon(Icons.bookmark_add):Icon(
                        Icons.bookmark_add_outlined,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  // child: Row(
                  //   children: genres.map((genre){
                  //     return Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 5),
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 10,
                  //             vertical:5),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white10,
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         child: Text(genre),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  child: SizedBox(
                    height: 30,
                    child: ListView.builder(
                      shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: genres.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(genres[index]),
                            ),
                          );
                        },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.data.title,style: TextStyle(fontWeight:
                            FontWeight.bold,fontSize: 18,),),
                            SizedBox(height: 10,),
                            Text("Released: ${widget.data.releaseDate}",style:
                            TextStyle(fontSize: 12,color: Colors.grey,),),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,
                                vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("TMDb:",style: TextStyle(color: Colors.black),),
                          ),
                          SizedBox(width: 2,),
                          Icon(Icons.star,color: Colors.yellow,),
                          SizedBox(width: 2,),
                          Text("${widget.data.voteAverage.toString()
                              .substring(0,3)}/10"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text("Overview",style: TextStyle(fontSize: 16,fontWeight:
                  FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text(widget.data.overView,style: TextStyle(color: Colors
                      .grey,fontSize: 12),),
                  SizedBox(height: 10,),
                  Text("Cast & Characters",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  castCharacter(),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () async{
                        // setState(() {
                        //   ytLink = link;
                        // });
                        if(trailerKey.isNotEmpty){
                          // final link = Uri.parse("https://www.youtube.com/watch?v=$trailerKey");
                          isWatchList = await Navigator.push(context,
                              MaterialPageRoute(builder:
                              (context) => WatchNow(link: trailerKey, mode:
                              widget.mode, id: widget.data.id,),));
                          setState(() {

                          });
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.grey.shade900,
                                  content: Text(
                                      "Currently not Available",
                                    style: TextStyle(color: Colors.white),
                                  )
                              )
                          );
                        }

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow,color: Colors.black,),
                          SizedBox(width: 5,),
                          Text("Watch Now",style: TextStyle(color: Colors
                              .black),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Available on",style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  // similar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
