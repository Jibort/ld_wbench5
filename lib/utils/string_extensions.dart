// lib/utils/string_extensions.dart
// Extensions per facilitar la gestió de strings i formats
// Created: 2025/05/06 dt. CLA

import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Extensions útils per a strings
extension StringExtensions on String {
  /// Retorna la traducció d'aquest string
  String get tx => L.tx(this);
  
  /// Retorna la traducció d'aquest string amb format aplicat
  String txFormat(List<dynamic> args) => L.tx(this, args);
  
  /// Aplica format reemplaçant {0}, {1}, etc. amb els arguments proporcionats
  String format(List<dynamic> args) {
    String result = this;
    
    // Imprimir per depuració
    Debug.info("Format: text original = '$result', args = $args");
    
    // Assegurar-nos que el patró de substitució funciona
    for (int i = 0; i < args.length; i++) {
      String placeholder = '{$i}';
      String replacement = args[i].toString();
      result = result.replaceAll(placeholder, replacement);
      Debug.info("Format: reemplaçant '$placeholder' per '$replacement', resultat = '$result'");
    }
    return result;
  }
  
  /// Extreu la clau de traducció d'un string (només la part que comença amb ##)
  String get extractKey {
    if (!startsWith('##')) return this;
    
    // Buscar el primer caràcter d'espai o símbol especial
    final RegExp symbolPattern = RegExp(r'[\s\{\.\:\;\,\-]');
    final match = symbolPattern.firstMatch(this);
    
    if (match == null) {
      // No hi ha símbols, tota la cadena és la clau
      return this;
    } else {
      // Retornar només la part de la clau
      return substring(0, match.start);
    }
  }
}
