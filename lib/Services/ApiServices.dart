

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class ApiService{

  ApiService();
 // http://emps.g10.pw:6025/organization/vendor/login
 // static String baseUrl = "http://emps.g10.pw:6025/organization/";
  //static String baseUrl = "http://emps.g10.pw:6025/employee/";
 // static String baseUrl = "https://api-emps.g10.pw/driver/app/";

  //static String baseUrl = "https://api-emps.g10.pw/escort/"; //Production
  static String baseUrl = "https://mobile.travelday.in/api/"; //Development



  apiRequest(String url, Map jsonMap) async {

    bool trustSelfSigned = true;
    String finalurl=baseUrl+url;
    print("finalurl==== $finalurl");
    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(finalurl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    final respon = await response.transform(utf8.decoder).join();
    print("respon==== $respon");
    httpClient.close();
    return respon;
  }

}