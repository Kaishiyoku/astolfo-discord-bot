import 'dart:mirrors';

import 'package:logging/logging.dart';

import 'BaseCommand.dart';

class HelpCommand extends BaseCommand {
  final _logger = Logger('HelpCommand');

  final List<Object> _availableCommands;

  final Map<String, Function> _commands = {
    'help': showHelp,
  };

  HelpCommand(this._availableCommands);

  get commands => _commands;

  bool call(String commandMessage, event) {
    if (_commands.containsKey(commandMessage)) {
      _logger.info('Command called: ${commandMessage}');

      Function commandFn = _commands[commandMessage];
      commandFn(_logger, _availableCommands, event);

      return true;
    }

    return false;
  }

  static Function showHelp = (logger, availableCommands, event) async {
    final String availableCommandsAsString = availableCommands.fold('Available commands:\n', (previousValue, commandObj) {
      ClassMirror classMirror = reflectClass(commandObj);
      InstanceMirror instanceMirror = classMirror.newInstance(new Symbol(''), [availableCommands]);
      Map<String, Function> commands = instanceMirror.getField(#commands).reflectee;
      List<String> commandNames = commands.keys.toList(growable: false);

      return '${previousValue}  ${commandNames.join('|')}\n';
    });

    event.message.reply('```${availableCommandsAsString}```');
  };
}