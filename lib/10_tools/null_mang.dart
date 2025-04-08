// null_mang.dart
// Eines per a ajudar a la gestió dels valors nulls.
// createdAt: 25/02/12 dc. JIQ

// Retorna cert només si 'pInst' NO ÉS nul.
bool isNotNull(dynamic pInst) {
  return !isNull(pInst);
}

// Retorna cert només si 'pInst' ÉS nul.
bool isNull(dynamic pInst) {
  return (pInst == null);
}

