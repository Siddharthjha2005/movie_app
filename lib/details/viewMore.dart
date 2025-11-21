import 'package:flutter/material.dart';

class ViewMore extends StatefulWidget {
  final List seasonData;
  final List episodeData;
  final seasonNo;
  final episodeNo;
  const ViewMore({super.key,required this.seasonData,required this
      .episodeData,this.seasonNo,this.episodeNo});

  @override
  State<ViewMore> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.seasonData.length,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context,{"seasonNo":widget.seasonNo,
                    "episodeNo":widget.episodeNo});
                },
                icon: Icon(Icons.arrow_back_outlined),
            ),
            title: Text("Season & Episodes"),
            bottom: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
                tabs: widget.seasonData.map((s){
                  return Tab(
                    child: Text("Season $s"),
                  );
                }).toList(),
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                  children: widget.seasonData.asMap().entries.map((entry){
                    int index = entry.key;
                    return ListView.builder(
                      itemCount: widget.episodeData[index].length,
                        itemBuilder: (context, epIndex) {
                        final ep = widget.episodeData[index][epIndex];
                          return Column(
                            children: [
                              ListTile(
                                onTap: (){
                                  int seasonNo = widget.seasonData[index];
                                  int episodeNo = widget
                                      .episodeData[index][epIndex].episodeNo;
                                  Navigator.pop(context,{"seasonNo":seasonNo,
                                    "episodeNo":episodeNo});
                                },
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
                                      ("S${widget.seasonData[index]} "
                                        "E${widget.episodeData[index][epIndex]
                                        .episodeNo}",style: TextStyle(fontSize: 12),),
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
                                trailing: Icon(Icons
                                    .arrow_downward_outlined),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(ep.desc,style: TextStyle(fontSize:
                                12,color: Colors.grey),),
                              ),
                              SizedBox(height: 10,),
                            ],
                          );
                        },
                    );
                  }).toList(),
              ),
              Positioned(
                bottom: 20,
                left: 140,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context,{"seasonNo":widget.seasonNo,
                      "episodeNo":widget.episodeNo});
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
                        Icon(Icons.keyboard_arrow_up),
                        Text("View Less",style: TextStyle
                          (fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
