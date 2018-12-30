import 'package:dartsicord/dartsicord.dart';

class Bot {
  String _token = '';
  final DiscordClient _client = new DiscordClient();

  Bot(token) {
    _token = token;
  }

  void run() {
    _client.onMessage.listen((event) async {
      if (event.message.content.toLowerCase() == '!astolfo') {
        await event.message.reply('pong');
      }
    });

    _client.connect(_token);
  }
}