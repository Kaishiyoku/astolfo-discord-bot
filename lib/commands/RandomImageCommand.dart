import 'package:logging/logging.dart';

import 'BaseCommand.dart';
import 'CommandException.dart';

class RandomImageCommand extends BaseCommand {
  final _logger = Logger('RandomImageCommand');

  @override
  final Map<String, Function> commands = {
    'safe': retrieveRandomImage('safe'),
    'questionable': retrieveRandomImage('questionable'),
    'explicit': retrieveRandomImage('explicit'),
  };

  RandomImageCommand(List<Object> availableCommands) : super(availableCommands);

  static Function retrieveRandomImage = ([String uri = '']) => (logger, availableCommands, event) async {
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