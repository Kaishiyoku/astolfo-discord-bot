import 'BaseCommand.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CommandException.dart';
import 'dart:io';

class RandomImageCommand extends BaseCommand {
  Map<String, Function> _commands = {
    'safe': retrieveRandomImage('safe'),
    'questionable': retrieveRandomImage('questionable'),
    'explicit': retrieveRandomImage('explicit'),
  };

  bool call(String commandMessage, event) {
    if (_commands.containsKey(commandMessage)) {
      print('command called: ${commandMessage}');

      Function commandFn = _commands[commandMessage];
      commandFn(event);

      return true;
    }

    return false;
  }

  static Function retrieveRandomImage = ([String uri = '']) => (event) async {
    try {
      await BaseCommand.getRequest(uri).then((response) => BaseCommand.responseBodyToJson(response)).then((json) {
        event.message.reply('Rating: ${json['rating']}\nViews: ${json['views']}\n<http://unlimitedastolfo.works/post/view/${json['external_id']}>\n${json['url']}');
      });
    } on CommandException catch(e) {
      print(e.message);

      event.message.reply('There was an error getting an image of Astolfo :cry:');
    }
  };
}