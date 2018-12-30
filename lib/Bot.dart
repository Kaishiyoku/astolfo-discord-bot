import 'dart:mirrors';

import 'package:dartsicord/dartsicord.dart';
import 'package:logging/logging.dart';

import 'commands/HelpCommand.dart';
import 'commands/RandomImageCommand.dart';

final String prefix = '!astolfo';

class Bot {
  final _logger = Logger('Bot');

  String _token;

  final DiscordClient _client = new DiscordClient();

  final List<Object> _availableCommands = [
    HelpCommand,
    RandomImageCommand,
  ];

  Bot(token) {
    _token = token;
  }

  void run() {
    _client.onMessage.listen((event) async {
      final String lowerCaseMessage = event.message.content.toLowerCase();

      if (lowerCaseMessage.startsWith('${prefix} ') || lowerCaseMessage == prefix) {
        final String adjustedMessage = lowerCaseMessage == prefix ? '${prefix} help' : lowerCaseMessage;
        final String commandMessage = adjustedMessage.substring(prefix.length + 1);

        // iterate commands
        bool result = _availableCommands.fold(false, (previousValue, Object commandObj) {
          ClassMirror classMirror = reflectClass(commandObj);
          InstanceMirror instanceMirror = classMirror.newInstance(new Symbol(''), [_availableCommands]);

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