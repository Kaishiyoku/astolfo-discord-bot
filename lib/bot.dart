import 'dart:io';

import 'package:dartsicord/dartsicord.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const availableCommands = [
  '!astolfo',
  '!astolfo unknown',
  '!astolfo safe',
  '!astolfo questionable',
  '!astolfo explicit',
];

class Bot {
  String _token = '';
  final DiscordClient _client = new DiscordClient();

  Bot(token) {
    _token = token;
  }

  void run() {
    _client.onMessage.listen((event) async {
      final String adjustedMessage = event.message.content.toLowerCase();

      if (availableCommands.contains(adjustedMessage)) {
        final String uri = adjustedMessage.split(' ').length > 1 ? adjustedMessage.split(' ')[1] : '';

        await http.get('https://astolfo.rocks/api/v1/images/random/${uri}', headers: {HttpHeaders.CONTENT_TYPE: "application/json"}).then((response) {
          var json = jsonDecode(response.body);

          event.message.reply('Rating: ${json['rating']}\nViews: ${json['views']}\n<http://unlimitedastolfo.works/post/view/${json['external_id']}>\n${json['url']}');
        }).catchError((e) {
          print('https://astolfo.rocks/api/v1/images/random/${uri}');
          event.message.reply('There was an error getting an image of Astolfo :cry:');
        });
      }
    });

    _client.connect(_token);
  }
}