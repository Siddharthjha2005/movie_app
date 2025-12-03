import 'package:share_plus/share_plus.dart';

class ShareAppLink {
  Future<bool> shareApp() async{
    final params = ShareParams(
      text: "Check out this awesome Movie App!\nWatch trending movies, TV shows, and track your favourites.\nDownload now: https://drive.google.com/uc?export=download&id=1xGTVnMvNhixgzXL49PvhMrqsA8uHzL4i",
      subject: "Share the Movie App",
    );

    final result = await SharePlus.instance.share(params);

    if(result.status == ShareResultStatus.success){
      return true;
    }
    return false;
  }
}