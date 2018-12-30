import 'dart:io';
import 'package:http/http.dart' as http;
import 'CommandException.dart';
import 'dart:convert';

class BaseCommand {
  static const BASE_URL = 'https://astolfo.rocks/api/v1/images/random';

  static responseBodyToJson(http.Response response) {
    return jsonDecode(response.body);
  }

  static Future<dynamic> getRequest(String uri) {
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };

    return http.get('${BASE_URL}/${uri}', headers: headers).then((http.Response response) {
      if (response.statusCode != HttpStatus.ok) {
        throw new CommandException('HTTP ${response.statusCode}');
      }

      return response;
    }).catchError((e) {
      throw new CommandException(e.message);
    });
  }
}
