import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'CommandException.dart';

class BaseCommand {
  static const BASE_URL = 'https://astolfo.rocks/api/v1/images/random';

  final _logger = Logger('BaseCommand');

  final List<Object> _availableCommands;

  Map<String, Function> commands = {};

  BaseCommand(this._availableCommands);

  bool call(String commandMessage, event) {
    if (commands.containsKey(commandMessage)) {
      _logger.info('Command called: ${commandMessage}');

      Function commandFn = commands[commandMessage];
      commandFn(_logger, _availableCommands, event);

      return true;
    }

    return false;
  }

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
