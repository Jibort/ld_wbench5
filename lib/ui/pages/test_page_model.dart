// test_page_model.dart
// Model de dades per a la pàgina de prova
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:ld_wbench5/core/base_model.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Model de dades per a la pàgina de prova
class TestPageModel extends SabinaModel {
  /// Títol de la pàgina
  String _title = '';
  
  /// Subtítol de la pàgina
  String? _subtitle;
  
  /// Constructor
  TestPageModel() {
    setTag('TestPageModel');
    _initializeValues();
  }
  
  /// Inicialitza els valors del model
  void _initializeValues() {
    _title = L.sSabina.tx;
    _subtitle = L.sAppSabina.tx;
    Debug.info("$tag: Model inicialitzat amb títol '$_title' i subtítol '$_subtitle'");
  }
  
  /// Obté el títol de la pàgina
  String get title => _title;
  
  /// Estableix el títol de la pàgina
  set title(String value) {
    if (_title != value) {
      notifyListeners(() {
        _title = value;
        Debug.info("$tag: Títol actualitzat a '$_title'");
      });
    }
  }
  
  /// Obté el subtítol de la pàgina
  String? get subtitle => _subtitle;
  
  /// Estableix el subtítol de la pàgina
  set subtitle(String? value) {
    if (_subtitle != value) {
      notifyListeners(() {
        _subtitle = value;
        Debug.info("$tag: Subtítol actualitzat a '$_subtitle'");
      });
    }
  }
  
  /// Actualitza els textos segons l'idioma actual
  void updateTexts() {
    title = L.sSabina.tx;
    subtitle = L.sAppSabina.tx;
  }
}