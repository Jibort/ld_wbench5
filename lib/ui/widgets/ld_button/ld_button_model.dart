// lib/ui/widgets/ld_button/ld_button_model.dart
// Model per al widget LdButton
// Created: 2025/05/06 dt. CLA 
// Updated: 2025/05/14 dc. CLA[JIQ] - Correcció completa de les constants de clau (cf/mf/ef) i suport per traduccions amb interpolació

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Tipus de botó disponibles per LdButton
enum ButtonType {
  elevated,
  filled,
  outlined,
  text,
}

/// Model per al widget LdButton
class   LdButtonModel 
extends LdWidgetModelAbs<LdButton> {
  // GETTERS/SETTERS ======================================

  IconData? get icon => config[cfIcon] as IconData?;
  set icon(IconData? val) => config[cfIcon] = val;

  ButtonStyle? get style => config[cfButtonStyle] as ButtonStyle?;
  set style(ButtonStyle? val) => config[cfButtonStyle] = val;

  // MEMBRES ==============================================
  /// Etiqueta del botó (clau de traducció o text directe)
  String _label = '';
  String get label => _label;
  set label(String value) {
    if (_label != value) {
      notifyListeners(() {
        _label = value;
        Debug.info("$tag: Label canviat a '$value'");
      });
    }
  }
  
  /// Paràmetres posicionals per a la traducció {0}, {1}, etc.
  List<String>? _positionalArgs;
  List<String>? get positionalArgs => _positionalArgs;
  set positionalArgs(List<String>? value) {
    if (_positionalArgs != value) {
      notifyListeners(() {
        _positionalArgs = value;
        Debug.info("$tag: Paràmetres posicionals canviats");
      });
    }
  }
  
  /// Paràmetres nomenats per a la traducció {name}, {count}, etc.
  LdMap<String>? _namedArgs;
  LdMap<String>? get namedArgs => _namedArgs;
  set namedArgs(LdMap<String>? value) {
    if (_namedArgs != value) {
      notifyListeners(() {
        _namedArgs = value;
        Debug.info("$tag: Paràmetres nomenats canviats");
      });
    }
  }
  
  /// Si el botó està habilitat
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;
  set isEnabled(bool value) {
    if (_isEnabled != value) {
      notifyListeners(() {
        _isEnabled = value;
        Debug.info("$tag: Estat d'activació canviat a $value");
      });
    }
  }
  
  /// Callback quan es prem el botó
  VoidCallback? onPressed;
  
  /// Tipus de botó
  ButtonType _buttonType = ButtonType.elevated;
  ButtonType get buttonType => _buttonType;
  set buttonType(ButtonType value) {
    if (_buttonType != value) {
      notifyListeners(() {
        _buttonType = value;
        Debug.info("$tag: Tipus de botó canviat a $value");
      });
    }
  }
  
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor des d'un mapa - seguint el patró correcte
  LdButtonModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
    // Carregar propietats específiques de LdButtonModel
    _loadFromMap(pMap);
    Debug.info("$tag: Model de botó creat des de mapa");
  }
  
  /// Constructor alternatiu per compatibilitat
  LdButtonModel.forWidget(LdButton widget, MapDyns pMap) 
    : super.forWidget(widget, pMap) {
    _loadFromMap(pMap);
    Debug.info("$tag: Model de botó creat per widget");
  }
  
  /// Carrega les propietats des d'un mapa
  void _loadFromMap(MapDyns pMap) {
    // Propietats de configuració UI (cf*)
    _label = pMap[cfLabel] as String? ?? '';
    _isEnabled = pMap[cfIsEnabled] as bool? ?? true;
    
    // Carregar paràmetres de traducció si existeixen (cf* perquè són configuració UI)
    if (pMap[cfPositionalArgs] != null) {
      _positionalArgs = List<String>.from(pMap[cfPositionalArgs]);
    }
    
    if (pMap[cfNamedArgs] != null) {
      _namedArgs = LdMap<String>();
      final sourceMap = pMap[cfNamedArgs] as Map;
      sourceMap.forEach((key, value) {
        _namedArgs![key.toString()] = value.toString();
      });
    }
    
    // Carregar tipus de botó (cf* perquè és configuració UI)
    final typeString = pMap[cfButtonType] as String?;
    if (typeString != null) {
      _buttonType = ButtonType.values.firstWhere(
        (e) => e.toString() == 'ButtonType.$typeString',
        orElse: () => ButtonType.elevated,
      );
    }
    
    Debug.info("$tag: Propietats carregades - label='$_label', enabled=$_isEnabled, type=$_buttonType");
  }
  
  // TRADUCCIÓ ============================================
  /// Obtenir l'etiqueta traduïda amb tots els paràmetres
  String get translatedLabel {
    if (_positionalArgs != null && _namedArgs != null) {
      return _label.tx(_positionalArgs!, _namedArgs!);
    } else if (_positionalArgs != null) {
      return _label.tx(_positionalArgs!, null);
    } else if (_namedArgs != null) {
      return _label.tx(null, _namedArgs!);
    } else {
      return _label.tx();
    }
  }
  
  // MAPEJAT ==============================================
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap);
    _loadFromMap(pMap);
  }
  
  @override
  MapDyns toMap() {
    final map = super.toMap();
    
    // Afegir propietats de configuració (cf*)
    map[cfLabel] = _label;
    map[cfIsEnabled] = _isEnabled;
    map[cfButtonType] = _buttonType.toString().split('.').last;
    
    if (_positionalArgs != null) {
      map[cfPositionalArgs] = _positionalArgs;
    }
    if (_namedArgs != null) {
      map[cfNamedArgs] = _namedArgs;
    }
    
    return map;
  }
  
  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case cfLabel: return _label;
      case cfIsEnabled: return _isEnabled;
      case cfButtonType: return _buttonType;
      case cfPositionalArgs: return _positionalArgs;
      case cfNamedArgs: return _namedArgs;
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
      case cfLabel:
        if (pValue is String || (pValue == null && pCouldBeNull)) {
          label = pValue as String? ?? '';
          return true;
        }
        break;
        
      case cfIsEnabled:
        if (pValue is bool || (pValue == null && pCouldBeNull)) {
          isEnabled = pValue as bool? ?? true;
          return true;
        }
        break;
        
      case cfButtonType:
        if (pValue is ButtonType) {
          buttonType = pValue;
          return true;
        } else if (pValue is String) {
          try {
            buttonType = ButtonType.values.firstWhere(
              (e) => e.toString() == 'ButtonType.$pValue',
            );
            return true;
          } catch (e) {
            Debug.warn("$tag: Tipus de botó no vàlid: $pValue");
          }
        }
        break;
        
      case cfPositionalArgs:
        if (pValue is List<String> || (pValue == null && pCouldBeNull)) {
          positionalArgs = pValue as List<String>?;
          return true;
        }
        break;
        
      case cfNamedArgs:
        if (pValue is LdMap<String> || (pValue == null && pCouldBeNull)) {
          namedArgs = pValue as LdMap<String>?;
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
  
  // VALIDACIÓ ============================================
  @override
  bool validate() {
    // Validar que l'etiqueta no sigui buida
    if (_label.trim().isEmpty) {
      Debug.warn("$tag: Validació fallida - etiqueta buida");
      return false;
    }
    
    return super.validate();
  }
}