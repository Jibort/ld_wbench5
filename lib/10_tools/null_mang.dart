// null_mang.dart
// Eines per a ajudar a la gestió dels valors nulls.
// createdAt: 25/02/12 dc. JIQ

/// Retorna cert només si 'pInst' NO ÉS nul.
bool isNotNull(dynamic pInst) {
  return !isNull(pInst);
}

/// Retorna cert només si 'pInst' ÉS nul.
bool isNull(dynamic pInst) {
  return (pInst == null);
}

/// Retorna cert només si la llista és nul·la o està buïda.
bool isEmpty(List? pList) => (pList == null || pList.isEmpty);

/// Retorna cert només si la llista no és nul·la i no està buïda.
bool isNotEmpty(List? pList) => !isNull(pList);