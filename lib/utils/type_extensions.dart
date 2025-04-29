// lib/utils/type_extensions.dart
// Extensió per obtenir el nom net d'una classe
// CreatedAt: 2025/04/29 dt. CLA[JIQ]

/// Extensió per obtenir el nom net d'una classe
extension ClassNameExtension on Type {
  /// Retorna el nom de la classe sense genèrics
  String get cleanClassName {
    String fullName = toString();
    return fullName.contains('<') 
      ? fullName.substring(0, fullName.indexOf('<')) 
      : fullName;
  }
}