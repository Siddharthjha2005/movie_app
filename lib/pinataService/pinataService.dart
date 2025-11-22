import 'dart:convert';

import 'package:http/http.dart' as http;

class PinataService {
  static const String _apiKey = "8061db1002ff8c4bb258";
  static const String _secretApiKey = "2103f304ae3a7b6437628902d8e0f0f0f909c2151e75b073908b0e49994a0ae7";

  Future<String?> uploadImage(String filePath) async {
    final url = Uri.parse("https://api.pinata.cloud/pinning/pinFileToIPFS");
    final request = http.MultipartRequest("POST", url)
      ..headers.addAll({
        "pinata_api_key": _apiKey,
        "pinata_secret_api_key": _secretApiKey,
      })
      ..files.add(await http.MultipartFile.fromPath("file", filePath));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse["IpfsHash"];
      }
      else {
        print("Failed to upload:${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image:$e");
      return null;
    }
  }
}