// lib/ui/widgets/ld_text/ld_label_model.dart
// Model de dades del widget LdText.
// Created: 2025/05/06 dt. CLA

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/ui/extensions/string_extensions.dart';

/// Model de dades del widget LdText.
class LdLabelModel extends LdWidgetModelAbs<LdLabel> {
  /// Retorna el controlador del widget.
  LdLabelCtrl get wCtrl => cWidget.wCtrl as LdLabelCtrl;
  
  /// Text o clau de traducció
  String _text = "";
  
  /// Arguments per format
  List<dynamic>? _args;
  
  /// Retorna el text traduït i formatat
  String get displayText {
    if (_text.startsWith('##')) {
      // Utilitzar directament el mètode tx amb arguments
      return L.tx(_text, _args);
    }
    
    // Si no és una clau, aplicar format directament al text si cal
    if (_args != null && _args!.isNotEmpty) {
      return _text.format(_args!);
    }
    
    return _text;
  }
  
  /// Retorna els arguents per format actuals.
  List<dynamic>? get args => _args;

  /// Estableix els arguments per format
  set args(List<dynamic>? value) {
    notifyListeners(() {
      _args = value;
      Debug.info("$tag: Arguments establerts a '$value'");
    });
  }

  /// Constructor General
  LdLabelModel(super.pWidget, {required String text, List<dynamic>? args}) {
    _text = text;
    _args = args;
    Debug.info("$tag: Model creat amb text '$text' i args '$args'");
  }

  /// Constructor des d'un mapa de valors.
  LdLabelModel.fromMap(super.pWidget, LdMap pMap) {
    fromMap(pMap);
  }

  /// 'LdModelAbs': Assigna els valors dels membres del model a partir d'un mapa.
  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    _text = pMap[mfText] as String;
    _args = pMap['args'] as List<dynamic>?;
  }

  /// Retorna un mapa amb els membres del model.
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfTag: tag,
      mfText: _text,
      'args': _args,
    });
    return map;
  }

  /// 'LdModelAbs': Retorna el valor d'un membre del model.
  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    if (pKey == mfText) {
      return _text;
    } else if (pKey == 'args') {
      return _args;
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
    if (pKey == mfText && pValue is String) {
      _text = pValue;
    } else if (pKey == 'args' && (pValue == null || pValue is List<dynamic>)) {
      args = pValue;
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