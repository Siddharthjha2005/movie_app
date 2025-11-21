import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFunction {

  String apiKey = "e71517aee4063b53db75fc5ed23c03ef";

  Future<List> fetchData(String mode,dynamic categoryID) async{
    List movieData = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/$mode/$categoryID?api_key=$apiKey");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        // List results = [];
        // if(categoryID.runtimeType==String){
        //   results = data['results'] ?? [];
        // }
        // else{
        //   if(data is List){
        //     results = data;
        //   }
        //   else if(data is Map){
        //     results = [data];
        //   }
        // }
        List results = categoryID.runtimeType==String?data['results']:[data];
        results.map((movie){
          movieData.add(MovieData(backImage: "https://image.tmdb"
              ".org/t/p/w780${movie['backdrop_path']}", id:
          movie['id'],
              title:
              mode=="movie"?movie['title']:movie['name'],
              overView:
              movie['overview'], posterImage: "https://image.tmdb"
                  ".org/t/p/w500${movie['poster_path']}", releaseDate:
              mode=="movie"?movie['release_date']:movie['first_air_date'],
              voteAverage: movie['vote_average'],mediaType: mode));
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return movieData;
    }
    catch (e){
      print("Error: $e");
      return movieData;
    }
  }

  Future<List> fetchGenre(String mode,int id) async{
    List genres = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/$mode/$id?api_key=$apiKey");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        List results = data['genres'];
        results.map((movie){
          genres.add(movie['name']);
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return genres;
    }catch (e){
      print("Error: $e");
      return genres;
    }
  }

  Future<List> fetchCast(String mode,int id) async{
    List cast = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/$mode/$id/credits?api_key=$apiKey");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        List results = data['cast'];
        results.map((movie){
          if(movie['profile_path']!=null){
            cast.add(MovieCast(name: movie['name'], profileImage:
            "https://image.tmdb"
                ".org/t/p/w185${movie['profile_path']}",character:
            movie['character']));
          }
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return cast;
    }catch (e){
      print("Error: $e");
      return cast;
    }
  }

  Future<List> fetchSimilar(String mode,int id) async{
    final similar = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/$mode/$id/similar?api_key=$apiKey");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        final results = data['results'];
        results.map((movie){
          if(movie['backdrop_path']!=null && movie['poster_path']!=null){
            similar.add(MovieData(backImage: "https://image.tmdb"
                ".org/t/p/w780${movie['backdrop_path']}", id: movie['id'],title:
            mode=="movie"?movie['title']:movie['name'],
                overView:
                movie['overview'], posterImage: "https://image.tmdb"
                    ".org/t/p/w500${movie['poster_path']}", releaseDate:
                mode=="movie"?movie['release_date']:movie['first_air_date'],
                voteAverage: movie['vote_average'],mediaType: mode));
          }
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return similar;
    }
    catch (e){
      print("Error: $e");
      return similar;
    }
  }

  Future<List> fetchTrending(String mode) async{
    List trendingData = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/trending/$mode/week?api_key=$apiKey");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        List results = data['results'];
        results.map((movie){
          trendingData.add(MovieData(backImage: "https://image.tmdb"
              ".org/t/p/w780${movie['backdrop_path']}", id: movie['id'],title:
          movie['media_type']=="movie"?movie['title']:movie['name'],
              overView:
              movie['overview'], posterImage: "https://image.tmdb"
                  ".org/t/p/w500${movie['poster_path']}", releaseDate:
              movie['media_type']=="movie"?movie['release_date']:movie
              ['first_air_date'],
              voteAverage: movie['vote_average'],mediaType:
              movie['media_type']));
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return trendingData;
    }
    catch (e){
      print("Error: $e");
      return trendingData;
    }
  }

  Future<List> fetchSearchResults(String query) async{
    List searchList = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/search/multi?api_key=$apiKey&query=$query");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        final results = data['results'];
        results.map((search){
          if(search['backdrop_path']!=null && search['poster_path']!=null &&
              (search['media_type']=="movie" || search['media_type']=="tv")){

            searchList.add(MovieData(backImage: "https://image.tmdb"
                ".org/t/p/w780${search['backdrop_path']}", id: search['id'],title:
            search['media_type']=="movie"?search['title']:search['name'],
                overView:
                search['overview'], posterImage: "https://image.tmdb"
                    ".org/t/p/w500${search['poster_path']}", releaseDate:
                search['media_type']=="movie"?search['release_date']:search
                ['first_air_date'],
                voteAverage: search['vote_average'],mediaType:
                search['media_type']));

          }
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return searchList;
    }
    catch (e){
      print("Error: $e");
      return searchList;
    }
  }

  // Future<String> getRequestToken() async{
  //   String token = "";
  //   final url = Uri.parse("https://api.themoviedb"
  //       ".org/3/authentication/token/new?api_key=$apiKey");
  //   final response = await http.get(url);
  //   try{
  //     if(response.statusCode==200){
  //       final data = jsonDecode(response.body);
  //       token = data['request_token'];
  //     }
  //     else{
  //       print(response.statusCode);
  //     }
  //     return token;
  //   }
  //   catch (e){
  //     print("Error: $e");
  //     return token;
  //   }
  // }

  Future<String> fetchTrailerKey(String mode,int id,int seasonNo,int episodeNo)
  async{
    String key = "";
    if(seasonNo==0 && episodeNo==0){
      final url = Uri.parse("https://api.themoviedb"
          ".org/3/$mode/$id/videos?api_key=$apiKey");
      final response = await http.get(url);
      try{
        if(response.statusCode==200){
          final data = jsonDecode(response.body);
          final results = data['results'];
          for(var video in results){
            if(video['type']=="Trailer" && video['site']=="YouTube" &&
                video['key']!=null){
              key = video['key'];
              print("Api: $key");
              break;
            }
          }
        }
        else{
          print(response.statusCode);
        }
        return key;
      }
      catch (e){
        print("Error: $e");
        return key;
      }
    }
    else{
      final url = Uri.parse("https://api.themoviedb"
          ".org/3/$mode/$id/season/$seasonNo/episode/$episodeNo?api_key=$apiKey&append_to_response=videos");
      final response = await http.get(url);
      try{
        if(response.statusCode==200){
          final data = jsonDecode(response.body);
          final results = data['videos']['results'];
          for(var video in results){
            if(video['type']=="Clip" && video['site']=="YouTube" &&
                video['key']!=null){
              key = video['key'];
              print("Api: $key");
              break;
            }
          }
        }
        else{
          print(response.statusCode);
        }
        return key;
      }
      catch (e){
        print("Error: $e");
        return key;
      }
    }
  }

  Future<List> fetchSeason(String mode,int id) async{
    List seasonList = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/$mode/$id?api_key=$apiKey");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        final results = data['seasons'];
        results.map((season){
          if(season['season_number']!=null){
            seasonList.add(season['season_number']);
          }
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return seasonList;
    }
    catch (e){
      print("Error: $e");
      return seasonList;
    }
  }

  Future<List> fetchEpisodes(String mode,int id,int seasonNo) async{
    List episodeList = [];
    final url = Uri.parse("https://api.themoviedb"
        ".org/3/$mode/$id/season/$seasonNo?api_key"
        "=$apiKey");
    final response = await http.get(url);
    try{
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        final results = data['episodes'];
        results.map((episode){
          if(episode['still_path']!=null && episode['name']!=null &&
              episode['air_date']!=null && episode['runtime']!=null &&
              episode['overview']!=null){
              episodeList.add(Episode(episodeNo: episode['episode_number'],image: "https://image.tmdb"
                  ".org/t/p/w300${episode['still_path']}", title: episode['name'],
                  date:
                  episode['air_date'], time: episode['runtime'],desc:
                  episode['overview']));
          }
        }).toList();
      }
      else{
        print(response.statusCode);
      }
      return episodeList;
    }
    catch (e){
      print("Error: $e");
      return episodeList;
    }
  }


}

class Episode{
  int episodeNo;
  String image;
  String title;
  String date;
  int time;
  String desc;
  Episode({required this.episodeNo,required this.image,required this.title,required this
      .date,
  required this.time,required this.desc});
}

class Season {
  int seasonNo;
  int episodes;
  Season({required this.seasonNo,required this.episodes});
}

class MovieCast {
  String name;
  String profileImage;
  String character;
  MovieCast({required this.name,required this.profileImage,required this.character});
}

class MovieData {
  String backImage;
  int id;
  String title;
  String overView;
  String posterImage;
  String releaseDate;
  double voteAverage;
  String? mediaType;
  MovieData({required this.backImage,required this.id,required this.title,
    required this.overView,required this.posterImage,required this
        .releaseDate,required this.voteAverage, this.mediaType});
}