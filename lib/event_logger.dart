import 'package:logger/logger.dart';

class EventPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return ['* ${event.level.name}: ${event.message}'];
  }
}

final logger = Logger(printer: EventPrinter());
