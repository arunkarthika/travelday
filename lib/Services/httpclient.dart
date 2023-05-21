
import 'dart:convert';
import 'dart:io';


class HttpUrlRequest{
  //static String baseurl = 'https://api-emps.g10.pw/employee/';
  //static String empbaseurl = 'https://api-emps.g10.pw/'; //Production
  static String empbaseurl = 'https://qasapi-emps.g10.pw/'; //Development

  static Future<String> apiRequest(String url, Map jsonMap) async {
    String strfinalurl = empbaseurl+url;
    HttpClient httpClient =  HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(strfinalurl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    print("reply=====$reply");
    httpClient.close();
    return reply;
  }

}