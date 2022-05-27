import 'dart:convert';

import 'package:fanfare_test/data/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class PostRepository {
  String baseUrl = "http://10.0.2.2:5000";

  Map<String, String> headers = <String, String>{
    "content-type": "application/json"
  };

  Future<PostModel> get() async {
    var response = await http.get(
      Uri.parse(baseUrl + '/post/getData'),
    );
    return PostModel.fromJson(json.decode(response.body)["data"]);
  }

  Future<http.Response> post(Map<String, dynamic> data) async {
    var response = await http.post(
      Uri.parse(baseUrl + '/post/create'),
      body: json.encode(data),
      headers: headers,
    );

    Logger().i(response.body);
    Logger().i(response.statusCode);
    return response;
  }

  Future<http.Response> update(Map<String, dynamic> data) async {
    var response = await http.post(
      Uri.parse(baseUrl + '/post/update'),
      body: json.encode(data),
      headers: headers,
    );

    Logger().i(response.body);
    Logger().i(response.statusCode);
    return response;
  }

  Future<http.StreamedResponse> patchImage(String filepath) async {
    var request =
        http.MultipartRequest('patch', Uri.parse(baseUrl + '/post/add/video'));
    request.files.add(await http.MultipartFile.fromPath("vid", filepath));
    request.headers.addAll({"Content-type": "multipart/form-data"});
    var response = request.send();
    return response;
  }
}
