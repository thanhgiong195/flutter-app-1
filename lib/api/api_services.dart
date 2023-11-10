import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_urls.dart';

class ApiServices {
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future generateTag(body) {
    var url = Uri.parse(ApiUrls.API_BASE_URL);
    return http
        .post(url, body: json.encode(body), headers: headers)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future activeTag(id, body) {
    var url = Uri.parse(ApiUrls.API_BASE_URL + '/' + id);
    return http
        .put(url, body: json.encode(body), headers: headers)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
