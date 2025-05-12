// test_page_model.dart
// Model de dades per a la pàgina de prova
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:ld_wbench5/core/ld_page/ld_page_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

/// Model de dades per a la pàgina de prova
class   TestPageModel
extends LdPageModelAbs<TestPage> {
  /// Títol de la pàgina.
  final StrFullSet _title = StrFullSet();
  
  /// Subtítol de la pàgina
  final StrFullSet _subTitle = StrFullSet();

  /// Comptador de proves
  int _counter = 0;
  
  /// CONSTRUCTORS --------------------
  TestPageModel({
    required TestPage pPage,
    required String pTitleKey,
    String? pSubTitleKey,
  }) : super.forPage(pPage, {}) {
    tag = className;
    // Carreguem els textos directament des del constructor
    updateTexts(pTitleKey, pSubTitleKey); 
  }

  /// Constructor des d'un mapa
  TestPageModel.fromMap(TestPage pPage, LdMap<dynamic> pMap) 
    : super.forPage(pPage, pMap) {
    fromMap(pMap);
  }

  /// Actualitza els textos segons l'idioma actual
  void updateTexts(String pTitleKey, String? pSubTitleKey) {
    _title.t = pTitleKey;
    _subTitle.t = pSubTitleKey ?? L.sAppSabina;
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
        Debug.info("$tag: Títol actualitzat a '$pTitleKey'");
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
        Debug.info("$tag: Subtítol actualitzat a '$pSubTitleKey'");
      });
    }
  }
  
  /// Obté el comptador
  int get counter => _counter;
  
  /// Incrementa el comptador
  void incrementCounter() {
    _counter++;
    
    // Notificar als observadors
    Debug.info("$tag: Comptador incrementat a $_counter");
    
    // Utilitza notifyListeners per forçar reconstrucció
    notifyListeners(() {
      // No fer res aquí, només forçar la reconstrucció
    });
  }

  /// Notifica que ha canviat l'idioma
  void changeLocale() {
    // Notificar als observadors
    Debug.info("$tag: Idioma canviat a ${L.getCurrentLocale()}");
    
    // Utilitza notifyListeners per forçar reconstrucció
    notifyListeners(() {
      // No fer res aquí, només forçar la reconstrucció
    });
  }

  // 'LdPageModelAbs' -----------------
  @override
  void fromMap(LdMap<dynamic> pMap) {
    super.fromMap(pMap);
    
    // Carregar des de configuració (cf) o model (mf)
    title = pMap[mfTitle] as String? ?? pMap[cfTitleKey] as String? ?? L.sAppSabina;
    subTitle = pMap[mfSubTitle] as String? ?? pMap[cfSubTitleKey] as String?;
    _counter = pMap[mfCounter] as int? ?? 0;
    
    Debug.info("$tag: Model carregat des de mapa amb títol='$title', comptador=$_counter");
  }

  /// Retorna un mapa amb els membres del model.
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfTag: tag,
      mfTitle: title,
      mfSubTitle: subTitle,
      mfCounter: _counter,
    });
    return map;
  }

  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfTitle: return title;
      case mfSubTitle: return subTitle;
      case mfCounter: return counter;
      default: return super.getField(
        pKey: pKey, 
        pCouldBeNull: pCouldBeNull, 
        pErrorMsg: pErrorMsg
      );
    }
  }

  @override
  bool setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfTitle:
        if (pValue is String) {
          title = pValue;
          return true;
        }
        break;
      case mfSubTitle:
        if (pValue is String? || pValue == null) {
          subTitle = pValue;
          return true;
        }
        break;
      case mfCounter:
        if (pValue is int) {
          _counter = pValue;
          return true;
        }
        break;
      default:
        return super.setField(
          pKey: pKey, 
          pValue: pValue, 
          pCouldBeNull: pCouldBeNull, 
          pErrorMsg: pErrorMsg
        );
    }
    return false;
  }
}