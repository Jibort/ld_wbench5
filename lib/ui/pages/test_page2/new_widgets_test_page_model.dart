// lib/ui/pages/test_page2/test_page2_model.dart
// Model de dades per a la pàgina de proves 2
// Created: 2025/05/17 ds. CLA

import 'package:ld_wbench5/core/ld_page/ld_page_model_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/pages/test_page2/test_page2.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

/// Model de dades per a la pàgina de proves 2
class TestPage2Model extends LdPageModelAbs<TestPage2> {
  /// Títol de la pàgina
  final StrFullSet _title = StrFullSet();
  
  /// Subtítol de la pàgina
  final StrFullSet _subTitle = StrFullSet();

  /// Comptador de proves per a widgets interactius
  int _counter = 0;
  
  /// CONSTRUCTORS --------------------
  TestPage2Model({
    required TestPage2 pPage,
    required String pTitleKey,
    String? pSubTitleKey,
  }) : super.forPage(pPage, {}) {
    tag = className;
    // Carreguem els textos directament des del constructor
    updateTexts(pTitleKey, pSubTitleKey); 
  }

  /// Constructor des d'un mapa
  TestPage2Model.fromMap(TestPage2 pPage, MapDyns pMap) 
    : super.forPage(pPage, pMap) {
    fromMap(pMap);
  }

  /// Actualitza els textos segons l'idioma actual
  void updateTexts(String pTitleKey, String? pSubTitleKey) {
    _title.t = pTitleKey;
    _subTitle.t = pSubTitleKey ?? L.sFeaturesDemo;
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Textos actualitzats amb l'idioma actual: ${L.getCurrentLocale().languageCode}");
  }

  // GETTERS/SETTERS ------------------
  /// Obté el títol de la pàgina
  String get title => _title.t!;
  
  /// Estableix el títol de la pàgina
  set title(String pTitleKey) {
    if (_title.t != pTitleKey) {
      notifyListeners(() {
        _title.t = pTitleKey;
        //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Títol actualitzat a '$pTitleKey'");
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
        //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Subtítol actualitzat a '$pSubTitleKey'");
      });
    }
  }
  
  /// Obté el comptador
  int get counter => _counter;
  
  /// Incrementa el comptador
  void incrementCounter() {
    _counter++;
    
    // Notificar als observadors
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Comptador incrementat a $_counter");
    
    // Utilitza notifyListeners per forçar reconstrucció
    notifyListeners(() {
      // No fer res aquí, només forçar la reconstrucció
    });
  }

  /// Notifica que ha canviat l'idioma
  void changeLocale() {
    // Notificar als observadors
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Idioma canviat a ${L.getCurrentLocale()}");
    
    // Utilitza notifyListeners per forçar reconstrucció
    notifyListeners(() {
      // No fer res aquí, només forçar la reconstrucció
    });
  }

  // 'LdPageModelAbs' -----------------
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap);
    
    // Carregar des de configuració (cf) o model (mf)
    title = pMap[mfTitle] as String? ?? pMap[cfTitleKey] as String? ?? L.sAppSabina;
    subTitle = pMap[mfSubTitle] as String? ?? pMap[cfSubTitleKey] as String?;
    _counter = pMap[mfCounter] as int? ?? 0;
    
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Model carregat des de mapa amb títol='$title', comptador=$_counter");
  }

  /// Retorna un mapa amb els membres del model.
  @override
  MapDyns toMap() {
    MapDyns map = super.toMap();
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