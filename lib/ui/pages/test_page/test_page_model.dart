// test_page_model.dart
// Model de dades per a la pàgina de prova
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/full_set.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';

/// Model de dades per a la pàgina de prova
class   TestPageModel
extends LdPageModelAbs {
  /// Títol de la pàgina.
  final FullSet<String> _title = FullSet<String>();
  
  /// Subtítol de la pàgina
  final FullSet<String?> _subTitle = FullSet<String?>();

  /// Comptador de proves
  int _counter = 0;
  
  /// CONSTRUCTORS --------------------
  TestPageModel({ required String? pTitle, String? pSubTitle }) {
    tag = className;
    _initializeValues(pTitle, pSubTitle);
  }
  
  /// Inicialitza els valors del model
  void _initializeValues(String? pTitle, String? pSubTitle) {
    _title.set(pTitle ?? L.sSabina.tx);
    _subTitle.set(pSubTitle ?? L.sAppSabina.tx);
    _counter = 0;
    Debug.info("$tag: Model inicialitzat amb títol '$_title', subtítol '$_subTitle' i comptador $_counter");
  }
  
  // GETTERS/SETTERS ------------------
  /// Obté el títol de la pàgina
  String get title => _title.get() ?? errInText;
  
  /// Estableix el títol de la pàgina
  set title(String value) {
    if (_title.get() != value) {
      notifyListeners(() {
        _title.set(value);
        Debug.info("$tag: Títol actualitzat a '$_title'");
      });
    }
  }
  
  /// Obté el subtítol de la pàgina
  String? get subTitle => _subTitle.get();
  
  /// Estableix el subtítol de la pàgina
  set subTitle(String? value) {
    if (_subTitle.get() != value) {
      notifyListeners(() {
        _subTitle.set(value);
        Debug.info("$tag: Subtítol actualitzat a '$_subTitle'");
      });
    }
  }
  
  /// Obté el comptador
  int get counter => _counter;
  
  /// Incrementa el comptador
  void incrementCounter() {
    notifyListeners(() {
      _counter++;
      Debug.info("$tag: Comptador incrementat a $_counter");
    });
  }
  
  /// Actualitza els textos segons l'idioma actual
  void updateTexts() {
    notifyListeners(() {
      title = L.sSabina.tx;
      subTitle = L.sAppSabina.tx;
    });
  }

  // 'LdPageModelAbs' -----------------
  @override // Arrel
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    title    = pMap[mfTitle] as String;
    subTitle = pMap[mfSubTitle] as String?;
    _counter = pMap[mfCounter] as int;
  }

  /// Retorna un mapa amb els membres del model.
  @override // Arrel
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfTag:      tag,
      mfTitle:    title,
      mfSubTitle: subTitle,
      mfCounter:  _counter,
    });
    return map;
  }

  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) 
  => (pKey == mfTitle)
    ? title
    : (pKey == mfSubTitle)
      ? subTitle 
      : (pKey == mfCounter)
          ? counter
          : super.getField(pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);

  @override
  void setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg})
  => (pKey == mfTitle && pValue is String)
    ? title = pValue
    : (pKey == mfSubTitle && pValue is String?)
      ? subTitle = pValue 
      : (pKey == mfCounter && pValue is int)
          ? _counter = pValue
          : super.setField(pKey: pKey, pValue: pValue, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
}