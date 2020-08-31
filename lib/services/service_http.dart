import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lahma/styles/strings.dart';

class HttpService {
  static final int statusCodeSuccess = 200;
  static HttpService _httpService = HttpService._();
  _HttpBaseClient _httpBaseClient;

  Future<http.Response> get(String url) async {
    print(url);
    String auth = 'Basic ' +
        base64Encode(utf8.encode(
            'ck_c9b02185ff5620da4302374f742c1eb3e04a4444:cs_fcd9671283085e15a2984e6451a235314b6ad55a'));
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: auth
      // HttpHeaders.authorizationHeader:"Bearer "+token,
    };
    return await _httpBaseClient.get(url, headers: headers);
  }

  Future<http.Response> get1(String url, String token) async {
    print("to $token");
    final headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token,
    };
    return await _httpBaseClient.get(url, headers: headers);
  }

  Future<http.Response> post(String url, Map<String, String> args) async {
    /* final headers = {
   // HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
   HttpHeaders.authorizationHeader:"Bearer "+token,
  }; */
    return await _httpBaseClient.post(url, body: args);
  }

  Future<http.Response> post1(
      String url, Map<String, String> args, String token) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: "Bearer " + token,
    };
    return await _httpBaseClient.post(url, body: args, headers: headers);
  }
  Future<http.Response> post4(
      String url, Map<String, String> args, String token) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json', 
    //  HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: "Bearer " + token,
    };
    return await _httpBaseClient.post(url, body: args, headers: headers);
  }

  Future<http.Response> post2(String url, String token) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: "Bearer " + token,
    };
    return await _httpBaseClient.post(url, headers: headers);
  }

  Future<http.Response> delete(String url, String token) async {
    print(url);
    final headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token,
    };
    return await _httpBaseClient.delete(url, headers: headers);
  }

  HttpService._() : _httpBaseClient = _HttpBaseClient(http.Client());
  static HttpService getInstance() => _httpService;
}

class _HttpBaseClient extends http.BaseClient {
  http.Client _httpClient;
  _HttpBaseClient(this._httpClient);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[USER_AGENT_KEY] = USER_AGENT_VALUE;
    return _httpClient.send(request);
  }
}
