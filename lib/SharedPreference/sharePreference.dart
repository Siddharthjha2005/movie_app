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

  Future<void> setPass(String pass) async{
    final pref = await SharedPreferences.getInstance();
    await pref.setString("Password",pass);
  }

  Future<String?> getUserName() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString("UserName");
  }

  Future<String?> getEmail() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString("Email");
  }

  Future<String?> getPass() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString("Password");
  }

  Future<bool?> getLoginStatus() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getBool("isLoggedIn");
  }

  Future<void> removeUserName() async{
    final pref = await SharedPreferences.getInstance();
    pref.remove("UserName");
  }

  Future<void> removePass() async{
    final pref = await SharedPreferences.getInstance();
    pref.remove("Password");
  }

  Future<void> allClear() async{
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

}