import 'dart:io';
import 'package:http/http.dart' as http;

class ApiMaster {
  var client = http.Client();
  final String baseUrl = "mika-care.mikaappliances.com";
  final String serverNameSpace = "/mobile";
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.connectionHeader: 'keep-alive',
  };
}
