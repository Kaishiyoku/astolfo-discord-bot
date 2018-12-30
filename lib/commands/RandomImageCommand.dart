import 'package:logging/logging.dart';

import 'BaseCommand.dart';
import 'CommandException.dart';

class RandomImageCommand extends BaseCommand {
  final _logger = Logger('RandomImageCommand');

  Map<String, Function> _commands = {
    'safe': retrieveRandomImage('safe'),
    'questionable': retrieveRandomImage('questionable'),
    'explicit': retrieveRandomImage('explicit'),
  };

  bool call(String commandMessage, event) {
    if (_commands.containsKey(commandMessage)) {
      _logger.info('Command called: ${commandMessage}');

      Function commandFn = _commands[commandMessage];
      commandFn(_logger, event);

      return true;
    }

    return false;
  }

  static Function retrieveRandomImage = ([String uri = '']) => (logger, event) async {
    try {
      await BaseCommand.getRequest(uri).then((response) => BaseCommand.responseBodyToJson(response)).then((json) {
        event.message.reply('Rating: ${json['rating']}\nViews: ${json['views']}\n<http://unlimitedastolfo.works/post/view/${json['external_id']}>\n${json['url']}');
      });
    } on CommandException catch(e) {
      logger.severe(e.message);

      event.message.reply('There was an error getting an image of Astolfo :cry:');
    }
  };
}