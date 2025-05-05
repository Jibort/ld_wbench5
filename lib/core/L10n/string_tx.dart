// lib/core/L10n/string_tx.dart
// Classe que actua o bé com a clau de traducció de texts o bé com un text literal.
// Created: 2025/05/04 dg. CLA[JIQ]

import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';

/// Classe que actua o bé com a clau de traducció de texts o bé com un text literal.
class StringTx {
  /// Clau de traducció (si és null, es considera text literal)
  String? _key;
  
  /// Text literal (si _key no és null, aquest s'ignora)
  String? _text;
  
  /// Crea un text (literal o clau) a partir d'una cadena de text.
  StringTx(String? pStr) {
    if (pStr == null || !pStr.startsWith("##")) {
      _key = null;
      _text = pStr;
    } else {
      _key = pStr;
      _text = null;
    }
  }
  
  /// Indica si el text és traduïble
  bool get isTranslatable => (_key != null);
  
  /// Indica si el text és nul.
  bool get isNull => _key == null && _text == null;

  /// Retorna la clau de traducció (o null si és literal)
  String? get key => _key;
  
  /// Retorna el text literal (o null si és traduïble)
  String? get literalText => _text;
  
  /// Retorna el text traduït o literal segons correspongui
  String? get text => isTranslatable ? L.tx(_key!) : literalText;
  
  /// Permet reestablir els valors segons les necessitats.
  void set(String? pText) {
    if (pText != null && pText.startsWith("##")) {
      _key  = pText;
      _text = null;
    } else {
      _text = pText;
      _key  = null;
    }
  }

  /// Crea una representació en string
  @override
  String toString() => text ?? errInText;
  
  /// Funció d'igualtat
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StringTx) return false;
    
    return (isTranslatable && other.isTranslatable && _key == other._key) ||
           (!isTranslatable && !other.isTranslatable && _text == other._text);
  }
  
  /// Funció de hash
  @override
  int get hashCode => isTranslatable ? _key.hashCode : _text.hashCode;
}