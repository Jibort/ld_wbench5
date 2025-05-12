// ld_button_model.dart
// Model del widget LdButton.
// Created: 2025-05-01 dc. JIQ
// Updated: 2025/05/12 dt. CLA - Implementació correcta del model de botó

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';

/// Model de dades del widget LdButton.
class LdButtonModel extends LdWidgetModelAbs<LdButton> {
  /// Text del botó
  String _text = "";
  String get text => _text;
  set text(String value) {
    if (_text != value) {
      notifyListeners(() {
        _text = value;
        Debug.info("$tag: Text del botó canviat a '$value'");
      });
    }
  }
  
  /// Icona del botó
  IconData? _icon;
  IconData? get icon => _icon;
  set icon(IconData? value) {
    if (_icon != value) {
      notifyListeners(() {
        _icon = value;
        Debug.info("$tag: Icona del botó canviada a '$value'");
      });
    }
  }
  
  /// Estat actiu/inactiu del botó
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;
  set isEnabled(bool value) {
    if (_isEnabled != value) {
      notifyListeners(() {
        _isEnabled = value;
        Debug.info("$tag: Estat del botó canviat a $value");
      });
    }
  }
  
  /// Constructor Generic
  LdButtonModel({
    required LdButton widget,
    String text = "",
    IconData? icon,
    bool isEnabled = true,
  }) : super.forWidget(widget, {}) {
    _text = text;
    _icon = icon;
    _isEnabled = isEnabled;
    Debug.info("$tag: Model del botó creat amb text='$text', hasIcon=${icon != null}");
  }
  
  /// Constructor des d'un mapa de valors.
  LdButtonModel.fromMap(LdMap<dynamic> pMap) : super.fromMap(pMap) {
    fromMap(pMap);
  }
  
  /// 'LdModelAbs': Assigna els valors dels membres del model a partir d'un mapa.
  @override
  void fromMap(LdMap<dynamic> pMap) {
    super.fromMap(pMap);
    _text = pMap[cfButtonText] as String? ?? "";
    _icon = pMap[cfIcon] as IconData?;
    _isEnabled = pMap[cfIsEnabled] as bool? ?? true;
    Debug.info("$tag: Model carregat des de mapa amb text='$_text'");
  }
  
  /// Retorna un mapa amb els membres del model.
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      cfButtonText: _text,
      cfIcon: _icon,
      cfIsEnabled: _isEnabled,
    });
    return map;
  }
  
  /// 'LdModelAbs': Retorna el valor d'un membre del model.
  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case cfButtonText: return text;
      case cfIcon: return icon;
      case cfIsEnabled: return isEnabled;
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
      case cfButtonText:
        if (pValue is String) {
          text = pValue;
          return true;
        }
        break;
      case cfIcon:
        if (pValue is IconData? || pValue == null) {
          icon = pValue;
          return true;
        }
        break;
      case cfIsEnabled:
        if (pValue is bool) {
          isEnabled = pValue;
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