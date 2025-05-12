// lib/ui/widgets/ld_label/ld_label_model.dart
// Model de dades del widget LdLabel.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/ui/extensions/string_extensions.dart';

/// Model de dades del widget LdLabel.
class LdLabelModel extends LdWidgetModelAbs<LdLabel> {
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
  
  /// Retorna el text intern sense traduir
  String get text => _text;
  
  /// Estableix el text intern
  set text(String value) {
    if (_text != value) {
      notifyListeners(() {
        _text = value;
        Debug.info("$tag: Text canviat a '$value'");
      });
    }
  }
  
  /// Retorna els arguments per format actuals.
  List<dynamic>? get args => _args;

  /// Estableix els arguments per format
  set args(List<dynamic>? value) {
    notifyListeners(() {
      _args = value;
      Debug.info("$tag: Arguments establerts a '$value'");
    });
  }

  /// Constructor General
  LdLabelModel(LdLabel widget, {required String text, List<dynamic>? args}) 
    : super.forWidget(widget, {}) {
    _text = text;
    _args = args;
    Debug.info("$tag: Model creat amb text '$text' i args '$args'");
  }

  /// Constructor des d'un mapa de valors.
  LdLabelModel.fromMap(LdLabel widget, LdMap<dynamic> pMap) 
    : super.forWidget(widget, pMap) {
    fromMap(pMap);
  }

  /// 'LdModelAbs': Assigna els valors dels membres del model a partir d'un mapa.
  @override
  void fromMap(LdMap<dynamic> pMap) {
    super.fromMap(pMap);
    _text = pMap[mfText] as String? ?? "";
    _args = pMap[mfArgs] as List<dynamic>?;
    Debug.info("$tag: Model carregat des de mapa amb text='$_text', args='$_args'");
  }

  /// Retorna un mapa amb els membres del model.
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfTag: tag,
      mfText: _text,
      mfArgs: _args,
    });
    return map;
  }

  /// 'LdModelAbs': Retorna el valor d'un membre del model.
  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfText: return _text;
      case mfArgs: return _args;
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
      case mfText:
        if (pValue is String) {
          text = pValue;
          return true;
        }
        break;
      case mfArgs:
        if (pValue == null || pValue is List<dynamic>) {
          args = pValue;
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