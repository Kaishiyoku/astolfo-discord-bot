import 'dart:io';

import 'package:args/args.dart';
import 'package:astolfo_discord_bot/Bot.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

main(List<String> arguments) {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) async {
    DateFormat dateFormat = new DateFormat('yyyy-MM-dd H:m:s');
    String formattedTime = dateFormat.format(record.time);
    String message = '${record.level.name}: ${formattedTime}: ${record.message}';

    print(message);

    var logFile = File('logs/output.log');
    var sink = logFile.openWrite(mode: FileMode.append);
    sink.writeln(message);

    await sink.flush();
    await sink.close();
  });

  const token = 'token';
  ArgResults argResults;

  final parser = new ArgParser()..addFlag(token, negatable: false, abbr: 't');
  argResults = parser.parse(arguments);

  if (!argResults[token]) {
    throw('Discord token required');
  }

  Bot bot = new Bot(argResults.rest.first);
  bot.run();
}
