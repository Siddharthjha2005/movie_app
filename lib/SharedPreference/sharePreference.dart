import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {

  Future<void> setLogInState(bool status) async{
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("isLoggedIn", status);
  }

  Future<void> setUserName(String username) async{
    final pref = await SharedPreferences.getInstance();
    await pref.setString("UserName",username);
  }

  Future<void> setEmail(String email) async{
    final pref = await SharedPreferences.getInstance();
    await pref.setString("Email",email);
  }

  Future<String?> getUserName() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString("UserName");
  }

  Future<String?> getEmail() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString("Email");
  }

  Future<bool?> getLoginStatus() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getBool("isLoggedIn");
  }

  Future<void> allClear() async{
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

}