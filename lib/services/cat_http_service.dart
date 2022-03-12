import 'dart:convert';

import 'package:cat_ui/models/breed_model.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../models/cat_model.dart';

class CatHttp{
  static String BASE_URL ="api.thecatapi.com";
  static Map<String,String> headers = {
    "Content-Type":"application/json",
    "x-api-key": "525201da-e1f6-477e-aadf-f8d789976cab"
  };

  static String API_PHOTO_LIST = "/v1/images/search";
  static String API_BREED = "/v1/breeds/search";
  static String API_BREEDS_ALL = "/v1/breeds";
  static String API_UPLOAD = "/v1/images/upload";
  static String API_GET_UPLOADS = "/v1/images/";
  static String API_DELETE = "/v1/images/"; //{id}

  // Methods
  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(BASE_URL, api, params);
    Response response = await get(uri, headers: headers);
    if(response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE_URL, api);
    Response response = await post(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> PUT(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE_URL, api);
    Response response = await put(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE_URL, api);
    Response response = await patch(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  static Future<String?> MULTIPART(
      String api, String filePath, Map<String, String> params) async {
    var uri = Uri.https(BASE_URL, api);
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.files.add(await MultipartFile.fromPath('file', filePath,
        contentType: MediaType("image", "jpeg")));
    request.fields.addAll(params);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  static Future<String?> DELETE(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE_URL, api, params);
    Response response = await delete(uri, headers: headers);
    if(response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  // Params
  static Map<String, String> paramEmpty() {
    Map<String, String> map = {};
    return map;
  }

  static Map<String, String> paramSearchName(String search,int pageNumber) {
    Map<String, String> params = {};
    params.addAll({
      "q":search,
      "page": pageNumber.toString(),
    });
    return params;
  }

  static Map<String,String> paramsSearch(int page){
    Map<String,String> params = {};
    params.addAll({
      "limit": "15",
      "page" : "$page",
      "order": "Desc"
    });
    return params;
  }

  static Map<String,dynamic> paramsSelect(int pageNumber,){
    Map<String,String> params = {};
    params.addAll({
      "page": "$pageNumber",
    });
    return params;
  }

  ///HTTP Service Parsing


  static List<Cat> parseCatList(String response){
    var data = catFromJson(response);
    return data;
  }

  static List<Breed> parseBreed(String response){
    var data = BreedFromJson(response);
    return data;
  }
  static List<Cat> parseResponse(String response) {
    List json = jsonDecode(response);
    List<Cat> photos = List<Cat>.from(json.map((x) => Cat.fromJson(x)));
    return photos;
  }
  static Map<String, dynamic> paramsPage(int pageNumber) {
    Map<String, String> params = {};
    params.addAll({
      'limit': '25',
      'page': pageNumber.toString()
    });
    return params;
  }
  static Map<String, String> bodyUpload() {
    Map<String, String> body = {
      'sub_id': ''
    };
    return body;
  }



}
