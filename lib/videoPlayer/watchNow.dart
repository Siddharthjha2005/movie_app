import 'package:flutter/material.dart';
import 'package:movie_app/details/viewMore.dart';
import 'package:movie_app/movieApi/apiFunction.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../details/Details.dart';

class WatchNow extends StatefulWidget {
  final String link;
  final String mode;
  final int id;
  const WatchNow({super.key,required this.link,required this.mode,required
  this.id});

  @override
  State<WatchNow> createState() => _WatchNowState();
}

class _WatchNowState extends State<WatchNow> {

  late YoutubePlayerController _controller;
  List similarData = [];
  List seasonData = [];
  List episodeData = [];
  int? currentSeason;
  int? currentEpisode;
  Map? record;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllData();
    final videoId = YoutubePlayer.convertUrlToId(widget.link);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        // hideControls: true,
      ),
    );
  }


  Future<void> fetchAllData() async{
    final similar = await ApiFunction().fetchSimilar(widget.mode, widget.id);
    if(widget.mode=="tv"){
      final season = await ApiFunction().fetchSeason(widget.mode,widget.id);
      List episodes = [];
      for(var seasonNo in season){
        final episode = await ApiFunction().fetchEpisodes(widget.mode, widget
            .id,
            seasonNo);
        episodes.add(episode);
      }

      setState(() {
        seasonData = season;
        episodeData = episodes;
      });
    }

    setState(() {
      similarData = similar;
    });
  }

  Future<void> fetchLink(int seasonNo,int episodeNo) async{
    final link = await ApiFunction().fetchTrailerKey(widget.mode, widget.id,
        seasonNo,
        episodeNo);

    if(link.isNotEmpty){
      _controller.load(link);
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

  }

  @override
  Widget build(BuildContext context) {

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  player,
                  Positioned(
                    top: 20,
                    left: 0,
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                        },
                      icon: Icon(Icons.arrow_back_outlined,color: Colors.white,),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 120,
                    child: IconButton(
                      onPressed: (){
                        final current = _controller.value.position;
                        final newPos = current - Duration(seconds: 10);
                        _controller.seekTo(newPos);
                        },
                      icon: Icon(Icons.keyboard_double_arrow_left,color:
                        Colors.white,),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    right: 120,
                    child: IconButton(
                      onPressed: (){
                        final current = _controller.value.position;
                        final newPos = current + Duration(seconds: 10);
                        _controller.seekTo(newPos);
                        },
                      icon: Icon(Icons.keyboard_double_arrow_right,color:
                        Colors.white,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){

                              },
                              child: Column(
                                children: [
                                  Icon(Icons.add,size: 20,),
                                  Text("Watchlist",style: TextStyle(fontSize: 12),),
                                ],
                              ),
                            ),
                            SizedBox(width: 30,),
                            Column(
                              children: [
                                Icon(Icons.share,size: 20,),
                                Text("Share",style: TextStyle(fontSize: 12),),
                              ],
                            ),
                            widget.mode=="movie"?SizedBox(width: 30,):Container(),
                            widget.mode=="movie"?Column(
                              children: [
                                Icon(Icons.arrow_downward_outlined,size: 20,),
                                Text("Download",style: TextStyle(fontSize:
                                12),),
                              ],
                            ):Container(),
                          ],
                        ),
                        widget.mode=="tv"?SizedBox(height: 10,):Container(),
                        widget.mode=="tv"?Text("Episodes",style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.bold),):Container(),
                        widget.mode=="tv"?DefaultTabController(
                            length: seasonData.length,
                            child: seasonData.isNotEmpty?Stack(
                              children: [
                                Column(
                                  children: [
                                    TabBar(
                                      tabAlignment: TabAlignment.start,
                                      isScrollable: true,
                                        tabs: seasonData.map((s){
                                          return Tab(
                                            child: Text("Season $s"),
                                          );
                                        }).toList(),
                                    ),
                                    SizedBox(
                                      height: 300,
                                      child: TabBarView(
                                          children: seasonData.asMap().entries.map((entry){
                                            int index = entry.key;
                                            return ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: episodeData[index]
                                                  .length,
                                                itemBuilder: (context,
                                                    epIndex) {
                                                final ep =
                                                episodeData[index][epIndex];
                                                  return GestureDetector(
                                                    onTap: (){
                                                      int seasonNo =
                                                      seasonData[index];
                                                      int episodeNo =
                                                      episodeData[index][epIndex].episodeNo;
                                                      setState(() {
                                                        currentSeason =
                                                            seasonNo;
                                                        currentEpisode =
                                                            episodeNo;
                                                      });
                                                      fetchLink(seasonNo,episodeNo);
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets
                                                          .symmetric(vertical: 2),
                                                      child: ListTile(
                                                        contentPadding:
                                                        EdgeInsets.only(right: 10),
                                                        leading: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.circular(5),
                                                            child: Image.network(ep.image)),
                                                        title: Text(ep.title,
                                                          style: TextStyle
                                                            (fontWeight:
                                                          FontWeight.bold,
                                                              fontSize: 14),),
                                                        subtitle: Row(
                                                          children: [
                                                            Text
                                                              ("S${seasonData[index]} E${episodeData[index][epIndex].episodeNo}",style: TextStyle(fontSize: 12),),
                                                            SizedBox(width: 5,),
                                                            Container(
                                                              width: 4,
                                                              height: 4,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            Text(ep.date
                                                                .toString(),style: TextStyle(fontSize: 12),),
                                                            SizedBox(width: 5,),
                                                            Container(
                                                              width: 4,
                                                              height: 4,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            Text("${ep.time
                                                                .toString()}m",
                                                        style: TextStyle(fontSize: 12),),
                                                          ],
                                                        ),
                                                        trailing: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: 10,
                                                              height: 10,
                                                              decoration: BoxDecoration(
                                                                color:
                                                                (
                                                                    (currentSeason==seasonData[index] || currentSeason==index+1)&& (currentEpisode==episodeData[index][epIndex].episodeNo|| currentEpisode==epIndex+1))?Colors.red:Colors.transparent,

                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            SizedBox(width:
                                                            10,),
                                                            Icon(Icons
                                                                .arrow_downward_outlined),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                            );
                                          }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 140,
                                  child: GestureDetector(
                                    onTap: () async {
                                      _controller.pause();
                                      record = await Navigator.push(context,
                                          MaterialPageRoute(builder:
                                              (context) => ViewMore
                                                (seasonData: seasonData,
                                                episodeData: episodeData,
                                                seasonNo: currentSeason,
                                                episodeNo: currentEpisode,),));
                                      setState(() {
                                        currentSeason = record?['seasonNo'];
                                        currentEpisode = record?['episodeNo'];
                                      });
                                      fetchLink(record?['seasonNo'],
                                          record?['episodeNo']);


                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal:
                                      10,vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade900,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.keyboard_arrow_down),
                                          Text("View More",style: TextStyle
                                            (fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ):Center(child: CircularProgressIndicator()),
                        ):Container(),
                        SizedBox(height: 10,),
                        Text("More Like This",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        similarData.isNotEmpty?GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: similarData.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                _controller.pause();
                                Navigator.push(context, MaterialPageRoute(builder:
                                    (context) => Details(data:
                                    similarData[index], mode: similarData[index]
                                    .mediaType)
                                  ,));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(similarData[index].posterImage,
                                  fit: BoxFit.cover,),
                              ),
                            );
                          },
                        ):Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        },
    );
  }
}
