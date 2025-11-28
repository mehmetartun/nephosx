import 'package:logger/logger.dart';

class Logs {
  static Logs get instance {
    _instance ??= Logs._internal();
    return _instance!;
  }

  static Logs? _instance;

  final Logger _logger = Logger();

  void setLevel(Level level) {
    Logger.level = level;
  }

  Logs._internal();

  void debug(String message) {
    _logger.d(message);
  }

  void error(String message) {
    _logger.e(message);
  }

  void info(String message) {
    _logger.i(message);
  }

  void warning(String message) {
    _logger.w(message);
  }

  void trace(String message) {
    _logger.t(message);
  }

  void fatal(String message) {
    _logger.f(message);
  }
}
