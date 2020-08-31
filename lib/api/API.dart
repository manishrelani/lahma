import 'package:http/http.dart';
import 'package:lahma/services/service_http.dart';

class API {
  static HttpService _httpService = HttpService.getInstance();
  //static String token;
  //static String session_id;

  static String DOMAIN_NAME = "https://lahma-sa.com/site/";
  static String GOOGLE_API = "AIzaSyB4BfDrt-mCQCC1pzrGUAjW_2PRrGNKh_U";
  static String oneStep = DOMAIN_NAME + "wp-json/digits/v1/one_click";
  static String product = DOMAIN_NAME + "wp-json/lahma/v1/products";
  static String coupons = DOMAIN_NAME + "wp-json/lahma/v1/coupons";
  static String address = DOMAIN_NAME + "wp-json/lahma/v1/address";
  static String profile = DOMAIN_NAME + "wp-json/lahma/v1/profile";
  static String checkout = DOMAIN_NAME + "wp-json/lahma/v1/checkout";
  static String oreder=DOMAIN_NAME+"wp-json/lahma/v1/orders?status=";

  static Future<Response> post(
      String api, Map<String, String> args) {
    print(args.toString());
    return _httpService.post(api, args);
  }

  static Future<Response> post1(
      String api, Map<String, String> args, String token) {
    print(args.toString());
    return _httpService.post1(api, args, token);
  }
  static Future<Response> post4(
      String api, Map<String, String> args, String token) {
    print(args.toString());
    return _httpService.post4(api, args, token);
  }
   static Future<Response> post2(
      String api, String token) {
    //print(args.toString());
    return _httpService.post2(api, token);
  }

  static Future<Response> get(String api) {
    return _httpService.get(api);
  }

  static Future<Response> get1(String api, String token) {
    print(api);
    return _httpService.get1(api, token);
  }

  static Future<Response> delete(int index, String token) {
    String api = address + "/$index";
    //print(api);
    return _httpService.delete(api, token);
  }
  static Future<Response> delete1(String api, String token) {
    //print(api);
    return _httpService.delete(api, token);
  }
}
