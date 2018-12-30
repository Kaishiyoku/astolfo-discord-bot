import 'dart:mirrors';

import 'package:logging/logging.dart';

import 'BaseCommand.dart';

class HelpCommand extends BaseCommand {
  final _logger = Logger('HelpCommand');

  @override
  final Map<String, Function> commands = {
    'help': showHelp,
    'author': showAuthor,
  };

  HelpCommand(List<Object> availableCommands) : super(availableCommands);

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

  static Function showAuthor = (logger, availableCommands, event) async {
    event.message.reply('My creator is <@278949013502296064> (https://astolfo.rocks)');
  };
}