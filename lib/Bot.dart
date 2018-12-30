import 'dart:mirrors';

import 'package:dartsicord/dartsicord.dart';
import 'package:logging/logging.dart';

import 'commands/RandomImageCommand.dart';

final String prefix = '!astolfo';

class Bot {
  final _logger = Logger('Bot');

  String _token;
  final DiscordClient _client = new DiscordClient();
  final List<Object> _commands = [
    RandomImageCommand,
  ];

  Bot(token) {
    _token = token;
  }

  void run() {
    _client.onMessage.listen((event) async {
      final String adjustedMessage = event.message.content.toLowerCase();

      if (adjustedMessage == prefix) {
        // TODO: make message generic
        event.message.reply('```Available commands:\n'
            + '!astolfo safe|questionable|explicit```');
      }

      if (adjustedMessage.startsWith('${prefix} ')) {
        final String commandMessage = adjustedMessage.substring(prefix.length + 1);

        // iterate commands
        bool result = _commands.fold(false, (previousValue, Object command) {
          ClassMirror classMirror = reflectClass(command);
          InstanceMirror instanceMirror = classMirror.newInstance(new Symbol(''),[]);

          return previousValue || instanceMirror.invoke(#call, [commandMessage, event]).reflectee;
        });

        if (!result) {
          _logger.warning('Command not found: ${commandMessage}');

          event.message.reply('Command not found :open_mouth:');
        }
      }
    });

    _client.connect(_token);
  }
}