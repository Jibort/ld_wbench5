// debug.dart
// Classe per a la generació de log en desenvolupament i proves.
// Created: 2025/04/29 dt. CLA[JIQ]

// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';

/// Nivells de debug
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
  // Nivells de debug actius
  static final Map<DebugLevel, bool> _activeLevels = {
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

  /// Activa tots els nivells de debug
  static void activateAllLevels() {
    for (var level in DebugLevel.values) {
      _activeLevels[level] = true;
    }
  }

  /// Desactiva tots els nivells de debug
  static void deactivateAllLevels() {
    for (var level in DebugLevel.values) {
      _activeLevels[level] = false;
    }
  }

  /// Activa nivells de debug específics
  static void activateLevels(List<DebugLevel> levels) {
    for (var level in levels) {
      _activeLevels[level] = true;
    }
  }

  /// Desactiva nivells de debug específics
  static void deactivateLevels(List<DebugLevel> levels) {
    for (var level in levels) {
      _activeLevels[level] = false;
    }
  }

  /// Registra un missatge de debug amb un nivell específic
  static void debug(DebugLevel level, String message) {
    if (kDebugMode && _activeLevels[level]!) {
      print("DEBG[${level.name}]: $message\n");
    }
  }

  /// Registra un missatge informatiu
  static void info(String message) {
    if (kDebugMode && _activeLevels[DebugLevel.info]!) {
      print("INFO: $message");
    }
  }

  /// Registra un avís
  static void warn(String message) {
    if (kDebugMode && _activeLevels[DebugLevel.warn]!) {
      print("WARN: $message");
    }
  }

  /// Registra un error
  static void error(String message, [Exception? exception]) {
    if (kDebugMode && _activeLevels[DebugLevel.error]!) {
      print("ERROR ⚠️: $message");
      if (exception != null) {
        print("EXCEPTION: ${exception.toString()}");
      }
    }
  }

  /// Registra un error fatal i llança una excepció
  static void fatal(String message, [Exception? exception]) {
    if (exception == null) {
      Error.throwWithStackTrace("FATAL ⚠️: $message", StackTrace.current);
    } else {
      Error.throwWithStackTrace(
        "FATAL ⚠️: $message\nEXCEPTION ⚠️: ${exception.toString()}",
        StackTrace.current,
      );
    }
  }
}