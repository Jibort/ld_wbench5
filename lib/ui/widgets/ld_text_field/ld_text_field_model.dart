// lib/ui/widgets/ld_text_field/ld_text_field_model.dart
// Model de dades del widget 'LdTextField'.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/11 ds. CLA - Adaptació completa a la nova arquitectura
// Updated: 2025/05/12 dt. CLA - Correcció del tipus de retorn de setField

import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';

/// Model de dades del widget LdTextField
class   LdTextFieldModel 
extends LdWidgetModelAbs<LdTextField> {
  // Text intern (dada real del model)
  String _text = "";
  String get text => _text;
  set text(String value) {
    if (_text != value) {
      notifyListeners(() {
        _text = value;
        Debug.info("$tag: Text canviat a '$value'");
      });
    }
  }

  // Constructor des d'un mapa
  LdTextFieldModel.fromMap(super.pMap) : super.fromMap() {
    // Les propietats es carregaran a fromMap
  }

  // Mapeig
  @override
  void fromMap(LdMap<dynamic> pMap) {
    super.fromMap(pMap);
    
    // Carregar propietats del model (mf)
    _text = pMap[mfText] as String? ?? pMap[mfInitialText] as String? ?? "";
    
    Debug.info("$tag: Model carregat des de mapa amb text='$_text'");
  }

  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfText: _text,
    });
    return map;
  }

  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfText: return text;
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
      case mfText:
        if (pValue is String) {
          text = pValue;
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

  // Netejar el text
  void clear() {
    notifyListeners(() {
      _text = "";
      Debug.info("$tag: Model netejat");
    });
  }
}