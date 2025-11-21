import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/SharedPreference/sharePreference.dart';
import 'package:movie_app/details/Details.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import '../movieApi/apiFunction.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Movie
  List nowPlayingMovieData = [];
  List upComingMovieData = [];
  List topRatedMovieData = [];
  List trendingMovieData = [];
  List popularMovieData = [];

  // Tv
  List airingTodayTvData = [];
  List topRatedTvData = [];
  List trendingTvData = [];
  List onTheAirTvData = [];
  List popularTvData = [];

  //Data
  String userName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllMovie();
    fetchAllTv();
    fetchLocalData();
  }

  Future<void> fetchLocalData() async{
    String? user = await SharePreference().getUserName();
    if(user!=null){
      setState(() {
        userName = user;
      });
    }
  }

  Future<void> fetchAllMovie() async{
    final nowPlaying = await ApiFunction().fetchData("movie","now_playing");
    final upComing = await ApiFunction().fetchData("movie","upcoming");
    final topRated = await ApiFunction().fetchData("movie","top_rated");
    final trending = await ApiFunction().fetchTrending("movie");
    final popular = await ApiFunction().fetchData("movie","popular");
    setState(() {
      nowPlayingMovieData = nowPlaying;
      upComingMovieData = upComing;
      topRatedMovieData = topRated;
      trendingMovieData = trending;
      popularMovieData = popular;
    });
  }

  Future<void> fetchAllTv() async{
    final airingToday = await ApiFunction().fetchData("tv","airing_today");
    final topRated = await ApiFunction().fetchData("tv","top_rated");
    final trending = await ApiFunction().fetchTrending("tv");
    final onTheAir = await ApiFunction().fetchData("tv","on_the_air");
    final popular = await ApiFunction().fetchData("tv","popular");
    setState(() {
      airingTodayTvData = airingToday;
      topRatedTvData = topRated;
      trendingTvData = trending;
      onTheAirTvData = onTheAir;
      popularTvData = popular;
    });
  }



  Widget header() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage("assets/images/person.jpg"),
      ),
      title: Text("Welcome, Back",style: TextStyle(color: Colors.grey),),
      subtitle: Text(userName,style: TextStyle(fontWeight: FontWeight
          .bold,fontSize: 18),),
      trailing: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        child: Icon(Icons.notifications_outlined),
      ),
    );
  }

  Widget slideShow(List data,String mode) {
    return data.isEmpty?Center(child:
    CircularProgressIndicator())
        :CarouselSlider.builder(
      itemCount: data.length,
      itemBuilder: (context, index, realIndex) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                Details(data: data[index],mode: mode,),));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              data[index].posterImage,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      options: CarouselOptions(
        aspectRatio: 16/8,
        autoPlay: true,
        viewportFraction: 0.32,
        enlargeCenterPage: true,
      ),
    );
  }

  Widget movieList(List data,String mode) {
    return data.isEmpty?Center(child: CircularProgressIndicator()):SizedBox(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  Details(data: data[index],mode: mode,),));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  data[index].posterImage,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget movie() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            slideShow(nowPlayingMovieData,"movie"),

            SizedBox(height: 10,),
            Text("Top Rated on TMDb",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight
                .bold),),
            SizedBox(height: 10,),
            movieList(topRatedMovieData,"movie"),

            SizedBox(height: 10,),
            Text("Latest Releases",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight
                .bold),),
            SizedBox(height: 10,),
            movieList(upComingMovieData,"movie"),

            SizedBox(height: 10,),
            Text("Trending Now",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight
                .bold),),
            SizedBox(height: 10,),
            movieList(trendingMovieData,"movie"),

            SizedBox(height: 10,),
            Text("Popular",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight.bold),),
            SizedBox(height: 10,),
            movieList(popularMovieData,"movie"),
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }

  Widget tv() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            slideShow(airingTodayTvData,"tv"),

            SizedBox(height: 10,),
            Text("Top Rated on TMDb",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight
                .bold),),
            SizedBox(height: 10,),
            movieList(topRatedTvData,"tv"),

            SizedBox(height: 10,),
            Text("Trending Now",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight
                .bold),),
            SizedBox(height: 10,),
            movieList(trendingTvData,"tv"),

            SizedBox(height: 10,),
            Text("On The Air",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight
                .bold),),
            SizedBox(height: 10,),
            movieList(onTheAirTvData,"tv"),

            SizedBox(height: 10,),
            Text("Popular",style: TextStyle(fontSize: 18,fontWeight:
            FontWeight.bold),),
            SizedBox(height: 10,),
            movieList(popularTvData,"tv"),
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          title: header(),
        ),
        // body: ,
        body: Column(
          children: [
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.only(left: 60,right: 60),
              child: SegmentedTabControl(
                indicatorPadding: EdgeInsets.all(5),
                indicatorDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(fontWeight: FontWeight.bold),
                barDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                tabs: [
                  SegmentTab(
                    label: "Movie Mode",
                    color: Colors.blue,
                    backgroundColor: Colors.white10,
                  ),
                  SegmentTab(
                    label: "TV Mode",
                    color: Colors.blue,
                    backgroundColor: Colors.white10,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: TabBarView(
                  children: [
                    movie(),
                    tv(),
                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// Popular:
// https://api.themoviedb.org/3/movie/popular?api_key=e71517aee4063b53db75fc5ed23c03ef
//
// Top Rated:
// https://api.themoviedb.org/3/movie/top_rated?api_key=e71517aee4063b53db75fc5ed23c03ef
//
// Upcoming:
// https://api.themoviedb.org/3/movie/upcoming?api_key=e71517aee4063b53db75fc5ed23c03ef
//
// Now Playing:
// https://api.themoviedb.org/3/movie/now_playing?api_key=e71517aee4063b53db75fc5ed23c03ef
//
// Trending (day):
// https://api.themoviedb.org/3/trending/movie/day?api_key=e71517aee4063b53db75fc5ed23c03ef
//
// Trending (week):
// https://api.themoviedb.org/3/trending/movie/week?api_key=e71517aee4063b53db75fc5ed23c03ef
//
// Latest (single movie):
// https://api.themoviedb.org/3/movie/latest?api_key=e71517aee4063b53db75fc5ed23c03ef
