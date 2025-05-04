// ld_app_bar_model.dart
// Model de dades del widget LdAppBar.
// Created: 2025-05-01 dc. JIQ
// Updated: 2025-05-05 dl. CLA - Millora del suport d'internacionalització

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

/// Model de dades del widget LdAppBar.
class   LdAppBarModel 
extends LdWidgetModelAbs<LdAppBar> {
  /// Retorna el controlador del widget.
  LdAppBarCtrl get wCtrl => cWidget.wCtrl as LdAppBarCtrl;
  
  /// Clau de traducció o text literal pel títol de la barra d'aplicació.
  final StrFullSet _titleKey = StrFullSet();
  
  /// Retorna el títol traduït de la barra d'aplicació.
  String get title {
    if (_titleKey.t != null && _titleKey.t!.startsWith("##")) {
      String translated = L.tx(_titleKey.t!);
      Debug.info("$tag: Títol traduït: '$translated' de clau '${_titleKey.t}'");
      return translated;
    }
    return _titleKey.t ?? errInText;
  }
  
  /// Estableix la clau de traducció o text literal pel títol de la barra d'aplicació.
  set title(String pTitle) {
    notifyListeners(() {
      _titleKey.t = pTitle;
      Debug.info("$tag: Clau/text de títol establert a '$pTitle'");
    });
  }

  /// Clau de traducció o text literal pel subtítol de la barra d'aplicació.
  final StrFullSet _subTitleKey = StrFullSet();
  
  /// Retorna el subtítol traduït de la barra d'aplicació.
  String? get subTitle {
    if (_subTitleKey.t != null && _subTitleKey.t!.startsWith("##")) {
      String translated = L.tx(_subTitleKey.t!);
      Debug.info("$tag: Subtítol traduït: '$translated' de clau '${_subTitleKey.t}'");
      return translated;
    }
    return _subTitleKey.t;
  }
  
  /// Estableix la clau de traducció o text literal pel subtítol de la barra d'aplicació.
  set subTitle(String? pSubTitle) {
    notifyListeners(() {
      _subTitleKey.t = pSubTitle;
      Debug.info("$tag: Clau/text de subtítol establert a '$pSubTitle'");
    });
  }
  
  /// Estableix el títol i el subtítol en la mateixa crida.
  void setTitles({required String pTitle, String? pSubTitle}) {
    notifyListeners(() {
      _titleKey.t = pTitle;
      _subTitleKey.t = pSubTitle;
      Debug.info("$tag: Títol i subtítol establerts a '$pTitle' i '$pSubTitle'");
    });
  }

  /// Actualitza les traduccions quan canvia l'idioma
  void updateTranslations() {
    bool hasTranslatableTexts = 
        (_titleKey.t != null && _titleKey.t!.startsWith("##")) || 
        (_subTitleKey.t != null && _subTitleKey.t!.startsWith("##"));
        
    if (hasTranslatableTexts) {
      notifyListeners(() {
        Debug.info("$tag: Textos actualitzats per canvi d'idioma");
        Debug.info("$tag: Títol actualitzat: '$title'");
        Debug.info("$tag: Subtítol actualitzat: '$subTitle'");
      });
    }
  }

  /// Constructor General
  LdAppBarModel(super.pWidget, {required String pTitle, String? pSubTitle}) {
    _titleKey.t = pTitle;
    _subTitleKey.t = pSubTitle;
    Debug.info("$tag: Model creat amb títol '$pTitle' i subtítol '$pSubTitle'");
  }

  /// Constructor des d'un mapa de valors.
  LdAppBarModel.fromMap(super.pWidget, LdMap pMap) {
    fromMap(pMap);
  }

  /// 'LdModelAbs': Assigna els valors dels membres del model a partir d'un mapa.
  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    title = pMap[mfTitle] as String;
    subTitle = pMap[mfSubTitle] as String?;
  }

  /// Retorna un mapa amb els membres del model.
  @override // Arrel
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfTag: tag,
      mfTitle: _titleKey.t,      // Guardem la clau original, no el text traduït
      mfSubTitle: _subTitleKey.t, // Guardem la clau original, no el text traduït
    });
    return map;
  }

  /// 'LdModelAbs': Retorna el valor d'un membre del model.
  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    if (pKey == mfTitle) {
      return title;
    } else if (pKey == mfSubTitle) {
      return subTitle;
    } else {
      return super.getField(
        pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
    }
  }

  /// 'LdModelAbs': Estableix el valor d'un membre del model.
  @override
  void setField({
    required String pKey, 
    dynamic pValue, 
    bool pCouldBeNull = true, 
    String? pErrorMsg
  }) {
    if (pKey == mfTitle && (pValue is String || pValue is StringTx)) {
      title = (pValue is StringTx) ? pValue.key ?? pValue.literalText ?? "" : pValue;
    } else if (pKey == mfSubTitle && (pValue is String? || pValue is StringTx?)) {
      subTitle = (pValue is StringTx) 
        ? pValue.key ?? pValue.literalText 
        : pValue as String?;
    } else if (pKey == "$mfTitle|$mfSubTitle" && pValue is String) {
      setTitles(
        pTitle: pValue.split(r"|").first,
        pSubTitle: pValue.split(r"|").last
      );
    } else {
      super.setField(
        pKey: pKey, 
        pValue: pValue, 
        pCouldBeNull: pCouldBeNull, 
        pErrorMsg: pErrorMsg
      );
    }
  }
}