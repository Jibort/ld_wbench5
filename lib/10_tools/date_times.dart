// date_times.dart
// Eines per a la manipulació de dates i de dates-hora.
// CreatedAt: 2025/04/13 dg. JIQ

/// Retorna la data/data-hora en format ISO8601.
String toIso8601(DateTime? pDateTime) =>
  pDateTime?.toIso8601String()?? "!?";
