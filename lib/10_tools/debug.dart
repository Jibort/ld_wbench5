// debug.dart
// Classe per a la generació de log en desenvolupament i proves.
// @createdAt: 2025/02/12 dc. JIQ

import 'package:flutter/foundation.dart';
import 'null_mang.dart';

const levelInfo = -1;
const levelWarn = -2;

enum DebugLevel {
  info,
  warn,
  
  debug_0,
  debug_1,
  debug_2,
  debug_3,
  debug_4,
  debug_5,
  debug_6,
  debug_7,
  debug_8,
  debug_9,
  
  error,
  fatal,
}

/// Classe per a la generació de log en desenvolupament i proves.
class Debug {
  // 📦 MEMBRES ESTÀTICS ---------------
  static Map<DebugLevel, bool> dLevels = {
    DebugLevel.info: true,
    DebugLevel.warn: true,
    DebugLevel.error: true,
    DebugLevel.fatal: true,
    DebugLevel.debug_0: true,
    DebugLevel.debug_1: true,
    DebugLevel.debug_2: true,
    DebugLevel.debug_3: true,
    DebugLevel.debug_4: true,
    DebugLevel.debug_5: true,
    DebugLevel.debug_6: true,
    DebugLevel.debug_7: true,
    DebugLevel.debug_8: true,
    DebugLevel.debug_9: true,
  };

  static void activateAllLevels() {
    for (var level in DebugLevel.values) {
      dLevels[level] = true;
    }
  }

  static void deactivateAllLevels() {
    for (var level in DebugLevel.values) {
      dLevels[level] = false;
    }
  }

  static void activateLevels(List<DebugLevel> pLevels) {
    for (var level in pLevels) {
      dLevels[level] = true;
    }
  }

  static void deactivateLevels(List<DebugLevel> pLevels) {
    for (var level in pLevels) {
      dLevels[level] = false;
    }
  }

  static void debug(DebugLevel pLevel, String pMsg) {
    if (dLevels[pLevel]!) {
      if (kDebugMode) {
        print("DEBG[${pLevel.name}]: $pMsg\n");
      }
    }
  }

  static void info(String pMsg) {
    if (dLevels[DebugLevel.info]!) {
      if (kDebugMode) {
        print("INFO: $pMsg");
      }
    }
  }

  static void warn(String pMsg) {
    if (dLevels[DebugLevel.warn]!) {
      if (kDebugMode) {
        print("WARN: $pMsg");
      }
    }
  }

  static void error(String pMsg, Exception? pExc) {
    if (dLevels[DebugLevel.error]!) {
      if (kDebugMode) {
        print("ERROR ⚠️: $pMsg");
        if (isNotNull(pExc)) {
          print("EXCEPTION: ${pExc.toString()}");
        }
      }
    }
  }

  static void fatal(String pMsg, Exception? pExc) {
    if (pExc == null) {
      Error.throwWithStackTrace("FATAL ⚠️: $pMsg", StackTrace.current);
    } else {
      Error.throwWithStackTrace(
        "FATAL ⚠️: $pMsg\nEXCEPTION ⚠️: ${pExc.toString()}",
        StackTrace.current,
      );
    }
  }
}
