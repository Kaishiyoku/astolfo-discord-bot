import 'package:args/args.dart';
import 'package:astolfo_discord_bot/bot.dart';

const token = 'token';
ArgResults argResults;

main(List<String> arguments) {
  final parser = new ArgParser()..addFlag(token, negatable: false, abbr: 't');
  argResults = parser.parse(arguments);

  if (!argResults[token]) {
    throw('Discord token required');
  }

  Bot bot = new Bot(argResults.rest.first);
  bot.run();
}
