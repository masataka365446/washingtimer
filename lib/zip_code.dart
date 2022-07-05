import 'dart:convert';

import 'package:http/http.dart';

class Zipcode {
  // static get response => null;

  static Future<Map<String, String>?> searchAddressFormZipcode(
      String zipCode) async {
    String url = 'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      Map<String, String> response = {};

      if (data['message'] != null) {
        response['message'] = data['message'];
      } else {
        if (data['results'] == null) {
          response['message'] = '正しい郵便番号を入力';
        } else {
          response['address'] = data['results'][0]['address2'];
        }
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
