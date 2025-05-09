// ld_button_model.dart
// Model del widget LdButton.
// Created: 2025-05-01 dc. JIQ

// Model del widget LdButton.
import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/full_set.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

class   LdButtonModel
extends LdWidgetModelAbs<LdButton> {
  /// Text del botó.
  final StrFullSet _text = StrFullSet();
  /// Retorna el text del botó.
  String? get text => _text.tx;
  set text(String? pTextOrKey)  => notifyListeners(() { _text.t = pTextOrKey ?? ""; });

  /// Icona del botó.
  final FullSet<IconData?> _iconData = FullSet<IconData?>();
  /// Retorna la icona del botó.
  IconData? get iconData => _iconData.get();
  /// Estableix la icona del botó.
  set iconData(IconData? pIconData) => notifyListeners(() { _iconData.set(pIconData); });

  /// Constructor General.
  LdButtonModel(super.pWidget, { String? pText, IconData? pIcon }) {
    text     = pText;
    iconData = pIcon;
  }

  /// Constructor des d'un mapa.
  LdButtonModel.fromMap(super.pWidget, LdMap pMap) { fromMap(pMap); }

  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    text = pMap[mfText] as String?;
    iconData = pMap[mfIconData] as IconData?;
  }

  /// Retorna un mapa amb els membres del model.
  @override // Arrel
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfTag:     tag,
      mfText:    text,
      mfIconData: iconData,
    });
    return map;
  }

  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) 
  => (pKey == mfText)
    ? text
    : (pKey == mfIconData)
      ? iconData
      : super.getField(pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
  
  @override
  void setField({required String pKey, pValue, bool pCouldBeNull = true, String? pErrorMsg})
  => (pKey == mfText && pValue is String?)
    ? text = pValue
    : (pKey == mfIconData && pValue is IconData?)
      ? iconData = pValue 
      : super.setField(pKey: pKey, pValue: pValue, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
}