import 'dart:developer';

import 'package:spike_flutter_sdk/spike_flutter_sdk.dart';

class PrintLogger extends SpikeLogger {
  const PrintLogger();

  // You specify if you want to receive debug messages through this logger.
  @override
  bool get isDebugEnabled => true;

  // You specify if you want to receive error messages through this logger.
  @override
  bool get isErrorEnabled => true;

  // You specify if you want to receive info messages through this logger.
  @override
  bool get isInfoEnabled => true;

  @override
  void debug(SpikeConnection connection, String message) =>
      _log(connection, message, 'debug');

  @override
  void error(SpikeConnection connection, String message) =>
      _log(connection, message, 'error');

  @override
  void info(SpikeConnection connection, String message) =>
      _log(connection, message, 'info');

  /*
  * Of course, in the production apps using 'print' is an antipattern in Flutter,
  * but this is intended to give you an idea how to use logger, and also to have
  * a compilable version of the logger to get you started as fast as possible.
  */
  void _log(SpikeConnection connection, String message, String level) =>
      log('[$level] [${connection.connectionId}]: $message');
}
