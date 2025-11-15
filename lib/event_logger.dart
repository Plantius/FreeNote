import 'package:logger/logger.dart';

class EventPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    const String yellow = '\x1B[33m';
    const String orange = '\x1B[38;5;214m';
    const String blue = '\x1B[34m';
    const String red = '\x1B[31m';
    const String reset = '\x1B[0m';

    String color = '';
    switch (event.level) {
      case Level.debug:
        color = yellow;
        break;

      case Level.warning:
        color = orange;
        break;

      case Level.fatal:
        color = red;
        break;

      case Level.info:
        color = blue;
        break;

      default:
        break;
    }
    
    return ['$color[${event.level.name}]$reset ${event.message}'];
  }
}

final logger = Logger(printer: EventPrinter());
