import 'package:flutter/material.dart';
import 'package:movie_app/details/Details.dart';
import 'package:movie_app/movieApi/apiFunction.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isClick = false;
  bool isChanged = false;
  // final _focusNode = FocusNode();
  List trendingData = [];
  var searchText = TextEditingController();
  List searchData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllTrending();
    // _focusNode.addListener((){
    //   setState(() {
    //     isClick = _focusNode.hasFocus;
    //   });
    // });
  }

  Future<void> fetchAllTrending() async{
    final trending = await ApiFunction().fetchTrending("all");
    setState(() {
      trendingData = trending;
      // print(trendingData);
    });
  }

  Future<void> fetchSearchContent(String value) async{
    final search = await ApiFunction().fetchSearchResults(value);
    setState(() {
      searchData = search;
      // print(searchData);
    });
  }

  Widget fetchRecords(List data,String title) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Text(title,style: TextStyle(fontSize: 18,fontWeight:
          FontWeight.bold),),
          SizedBox(height: 20,),
          data.isEmpty?Center(child: CircularProgressIndicator()):GridView
              .builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => Details(data:
                  data[index], mode: data[index]
                      .mediaType)
                    ,));
                  // FocusScope.of(context).unfocus();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(data[index].posterImage,
                    fit: BoxFit.cover,),
                ),
              );
            },
          ),
          SizedBox(height: 60,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: TextField(
          controller: searchText,
          // focusNode: _focusNode,
          onTap: (){
            setState(() {
              isClick = true;
            });
          },
          onChanged: (value) {
            setState(() {
              if(value.isNotEmpty){
                isChanged = true;
                fetchSearchContent(value);
              }
              else{
                isChanged = false;
                searchData.clear();
              }
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: isClick?Colors.white10:Colors.white,
            prefixIcon: IconButton(
              onPressed: (){
                setState(() {
                  if(isChanged){
                    searchData.clear();
                    searchText.clear();
                    isClick = false;
                    isChanged = false;
                    FocusScope.of(context).unfocus();
                  }
                });
              },
              icon: Icon(isChanged?Icons.arrow_back_outlined:Icons
                  .search_outlined,color:
              isClick?Colors
                  .white:Colors
                  .black,size:
              28,),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  if(isChanged){
                    searchText.clear();
                    searchData.clear();
                    isChanged = false;
                  }
                });
              },
              icon: Icon(isChanged?Icons.close:Icons.mic_none_outlined,
                color:
              isClick?Colors
                  .white:Colors.black,size:
              28,),
            ),
            hintText: "Search for 'movie & Tv show'",
            hintStyle: TextStyle(color: isClick?Colors.grey:Colors.black,
                fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          setState(() {
            isClick = false;
          });
        },
        child: searchData.isNotEmpty?fetchRecords(searchData, "Top Results") :fetchRecords(trendingData, "Trending "
            "in"),
      ),
    );
  }
}
