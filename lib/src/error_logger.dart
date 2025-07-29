import 'dart:developer';

import 'models/app_failure.dart';

class ErrorLogger {
  const ErrorLogger();

  void logError(AppFailure failure, Object e) {
    const red = '\x1B[31m';
    const yellow = '\x1B[33m';
    const bold = '\x1B[1m';
    const reset = '\x1B[0m';

    final buffer = StringBuffer()
      ..writeln('\n$red$bold❌ ERROR LOG START ❌$reset')
      ..writeln('$yellow🔸 Exception:$reset ${e.runtimeType}')
      ..writeln('$yellow🔸 Error Msg:$reset ${e.toString()}')
      ..writeln('$yellow🔸 Type     :$reset ${failure.runtimeType}')
      ..writeln('$yellow🔸 Code     :$reset ${failure.code}')
      ..writeln('$yellow🔸 Message  :$reset ${failure.message}')
      ..writeln(
        '$yellow🔸 Timestamp:$reset ${DateTime.now().toIso8601String()}',
      )
      ..writeln(
        '$yellow🔸 Stack    :$reset\n${_formatStack(failure.stackTrace)}',
      )
      ..writeln('$red$bold❌ ERROR LOG END ❌$reset\n');

    log(buffer.toString());
  }

  String _formatStack(StackTrace? stackTrace) {
    if (stackTrace == null) return 'No stack trace.';
    const cyan = '\x1B[36m';
    const gray = '\x1B[90m';
    const reset = '\x1B[0m';
    final lines = stackTrace.toString().split('\n');
    return lines.take(5).map((line) => '$gray↳ $cyan$line$reset').join('\n');
  }
}
