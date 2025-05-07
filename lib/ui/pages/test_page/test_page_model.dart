// test_page_model.dart
// Model de dades per a la pàgina de prova
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

/// Model de dades per a la pàgina de prova
class   TestPageModel
extends LdPageModelAbs {
  /// Model de dades de la pàgina
  TestPageCtrl get ctrl => cPage.vCtrl as TestPageCtrl;

  /// Títol de la pàgina.
  final StrFullSet _title = StrFullSet();
  
  /// Subtítol de la pàgina
  final StrFullSet _subTitle = StrFullSet();

  /// Comptador de proves
  int _counter = 0;
  
  /// CONSTRUCTORS --------------------
  TestPageModel({
    required super.pPage,
    required String pTitleKey,
    String? pSubTitleKey }) 
  { tag = className;
    // Carreguem els textos directament des del constructor
    updateTexts(pTitleKey, pSubTitleKey); 
  }

  /// Actualitza els textos segons l'idioma actual
  void updateTexts(String pTitleKey, String? pSubTitleKey) {
    _title.t = pTitleKey;
    _subTitle.t = pSubTitleKey?? L.sAppSabina;
    Debug.info("$tag: Textos actualitzats amb l'idioma actual: ${L.getCurrentLocale().languageCode}");
  }

  // GETTERS/SETTERS ------------------
  /// Obté el títol de la pàgina
  String get title => _title.t!;
  
  /// Estableix el títol de la pàgina
  set title(String pTitleKey) {
    if (_title.t != pTitleKey) {
      notifyListeners(() {
        _title.t = pTitleKey;
        Debug.info("$tag: Títol actualitzat a '$_title'");
      });
    }
  }
  
  /// Obté el subtítol de la pàgina
  String? get subTitle => _subTitle.t;
  
  /// Estableix el subtítol de la pàgina
  set subTitle(String? pSubTitleKey) {
    if (_subTitle.t != pSubTitleKey) {
      notifyListeners(() {
        _subTitle.t = pSubTitleKey;
        Debug.info("$tag: Títol actualitzat a '$_title'");
      });
    }
    if (_subTitle.t != pSubTitleKey) {
      notifyListeners(() {
        _subTitle.t = pSubTitleKey;
        Debug.info("$tag: Subtítol actualitzat a '$subTitle'");
      });
    }
  }
  
  /// Estableix el títol i el subtítol de la pàgina.
  setTitles({ required StringTx pTitle, StringTx? pSubTitle }) {
    if (_subTitle.get() != pSubTitle) {
      notifyListeners(() {
        _title.set(pTitle);
        _subTitle.set(pSubTitle);
        Debug.info("$tag: Títol actualitzat a    '$title'");
        Debug.info("$tag: Subtítol actualitzat a '$subTitle'");
      });
    }
  }

  /// Obté el comptador
  int get counter => _counter;
  
  /// Incrementa el comptador
void incrementCounter() {
  _counter++;
  notifyListeners(() {
    Debug.info("$tag: Comptador incrementat a $_counter");
    
    // Emetre un event de reconstrucció global
    EventBus.s.emit(LdEvent(
      eType: EventType.rebuildUI,
      srcTag: tag,
    ));
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

  @override getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) 
  => (pKey == mfTitle)
    ? title
    : (pKey == mfSubTitle)
      ? subTitle 
      : (pKey == mfCounter)
          ? counter
          : super.getField(pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);

  @override setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg})
  => (pKey == mfTitle && pValue is StringTx)
    ? _title.t = pValue.text
    : (pKey == mfSubTitle && pValue is StringTx?)
      ? _subTitle.t = pValue?.text
      : (pKey == mfCounter && pValue is int)
          ? _counter = pValue
          : super.setField(pKey: pKey, pValue: pValue, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
}