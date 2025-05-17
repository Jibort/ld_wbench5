// ld_app_bar_model.dart
// Model de dades del widget LdAppBar.
// Created: 2025-05-01 dc. JIQ
// Updated: 2025-05-05 dl. CLA - Millora del suport d'internacionalització
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

/// Model de dades del widget LdAppBar.
class   LdAppBarModel 
extends LdWidgetModelAbs<LdAppBar> {
  /// Clau de traducció o text literal pel títol de la barra d'aplicació.
  final StrFullSet _titleKey = StrFullSet();
  
  /// Retorna el títol traduït de la barra d'aplicació.
  String get titleKey {
    if (_titleKey.t != null && _titleKey.isKey) {
      String translated = _titleKey.tx!;
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Títol traduït: '$translated' de clau '${_titleKey.t}'");
      return translated;
    }
    return _titleKey.t ?? errInText;
  }
  
  /// Estableix la clau de traducció o text literal pel títol de la barra d'aplicació.
  set titleKey(String pTitleKey) {
    notifyListeners(() {
      _titleKey.t = pTitleKey;
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Clau/text de títol establert a '$pTitleKey'");
    });
  }

  /// Clau de traducció o text literal pel subtítol de la barra d'aplicació.
  final StrFullSet _subTitleKey = StrFullSet();
  
  /// Retorna el subtítol traduït de la barra d'aplicació.
  String? get subTitleKey {
    if (_subTitleKey.t != null && _subTitleKey.isKey) {
      String translated = _subTitleKey.tx!;
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Subtítol traduït: '$translated' de clau '${_subTitleKey.t}'");
      return translated;
    }
    return _subTitleKey.t;
  }
  
  /// Estableix la clau de traducció o text literal pel subtítol de la barra d'aplicació.
  set subTitleKey(String? pSubTitleKey) {
    notifyListeners(() {
      _subTitleKey.t = pSubTitleKey;
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Clau/text de subtítol establert a '$pSubTitleKey'");
    });
  }
  
  /// Estableix el títol i el subtítol en la mateixa crida.
  void setTitles({ required String pTitleKey, String? pSubTitleKey }) {
    notifyListeners(() {
      _titleKey.t = pTitleKey;
      _subTitleKey.t = pSubTitleKey;
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Títol i subtítol establerts a '$pTitleKey' i '$pSubTitleKey'");
    });
  }

  /// Actualitza les traduccions quan canvia l'idioma
  void updateTranslations() {
    notifyListeners(() {
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Textos actualitzats per canvi d'idioma");
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Títol actualitzat: '$titleKey'");
      if (subTitleKey != null) {
        //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Subtítol actualitzat: '$subTitleKey'");
      }
    });
  }

  /// Constructor General
  LdAppBarModel(LdAppBar widget, { required String pTitleKey, String? pSubTitleKey }) 
    : super.forWidget(widget, {}) {
    _titleKey.t = pTitleKey;
    _subTitleKey.t = pSubTitleKey;
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Model creat amb títol '$pTitleKey' i subtítol '$pSubTitleKey'");
  }

  /// Constructor des d'un mapa de valors.
  LdAppBarModel.fromMap(LdAppBar widget, MapDyns pMap) 
    : super.forWidget(widget, pMap) {
    fromMap(pMap);
  }

  /// 'LdModelAbs': Assigna els valors dels membres del model a partir d'un mapa.
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap);
    titleKey = pMap[mfTitle] as String? ?? pMap[cfTitleKey] as String? ?? "";
    subTitleKey = pMap[mfSubTitle] as String? ?? pMap[cfSubTitleKey] as String?;
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Model carregat des de mapa amb títol='$titleKey'");
  }

  /// Retorna un mapa amb els membres del model.
  @override
  MapDyns toMap() {
    MapDyns map = super.toMap();
    map.addAll({
      mfTag: tag,
      mfTitle: _titleKey.t,      // Guardem la clau original, no el text traduït
      mfSubTitle: _subTitleKey.t, // Guardem la clau original, no el text traduït
    });
    return map;
  }

  /// 'LdModelAbs': Retorna el valor d'un membre del model.
  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfTitle: return titleKey;
      case mfSubTitle: return subTitleKey;
      default: return super.getField(
        pKey: pKey, 
        pCouldBeNull: pCouldBeNull, 
        pErrorMsg: pErrorMsg
      );
    }
  }

  /// 'LdModelAbs': Estableix el valor d'un membre del model.
  @override
  bool setField({
    required String pKey, 
    dynamic pValue, 
    bool pCouldBeNull = true, 
    String? pErrorMsg
  }) {
    switch (pKey) {
      case mfTitle:
        if (pValue is String) {
          titleKey = pValue;
          return true;
        }
        break;
      case mfSubTitle:
        if (pValue is String? || pValue == null) {
          subTitleKey = pValue;
          return true;
        }
        break;
      case "$mfTitle|$mfSubTitle":
        if (pValue is String) {
          final parts = pValue.split("|");
          setTitles(
            pTitleKey: parts.first,
            pSubTitleKey: parts.length > 1 ? parts.last : null
          );
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