// lib/ui/widgets/ld_text_field/ld_text_field_model.dart
// Model de dades del widget 'LdTextField'.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/11 ds. CLA - Adaptació completa a la nova arquitectura

import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

/// Model de dades del widget LdTextField
class   LdTextFieldModel 
extends LdWidgetModelAbs<LdTextField> {
  // Text intern
  String _text = "";
  String get text => _text;
  set text(String value) {
    if (_text != value) {
      notifyListeners(() {
        _text = value;
        Debug.info("$tag: Text canviat a '$value'");
        
        // Si tenim un handler extern, notificar-lo
        if (_onTextChanged != null) {
          _onTextChanged!(_text);
        }
      });
    }
  }
  
  // Etiqueta
  final StrFullSet _label = StrFullSet();
  String? get label => _label.tx;
  set label(String? value) {
    notifyListeners(() {
      _label.t = value;
      Debug.info("$tag: Etiqueta canviada a '$value'");
    });
  }
  
  // Text d'ajuda
  final StrFullSet _helpText = StrFullSet();
  String? get helpText => _helpText.tx;
  set helpText(String? value) {
    notifyListeners(() {
      _helpText.t = value;
      Debug.info("$tag: Text d'ajuda canviat a '$value'");
    });
  }
  
  // Estat d'error
  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(bool value) {
    if (_hasError != value) {
      notifyListeners(() {
        _hasError = value;
        Debug.info("$tag: Estat d'error canviat a $value");
      });
    }
  }
  
  // Missatge d'error
  final StrFullSet _errorMessage = StrFullSet();
  String? get errorMessage => _errorMessage.tx;
  set errorMessage(String? value) {
    notifyListeners(() {
      _errorMessage.t = value;
      Debug.info("$tag: Missatge d'error canviat a '$value'");
    });
  }
  
  // Pot ser nul·la
  bool _allowNull = true;
  bool get allowNull => _allowNull;
  set allowNull(bool value) {
    if (_allowNull != value) {
      notifyListeners(() {
        _allowNull = value;
        Debug.info("$tag: Pot ser nul·la canviat a $value");
      });
    }
  }
  
  // Callback quan canvia el text
  Function(String)? _onTextChanged;
  Function(String)? get onTextChanged => _onTextChanged;
  set onTextChanged(Function(String)? value) {
    _onTextChanged = value;
  }
  
  // Constructor des d'un mapa
  LdTextFieldModel.fromMap(super.pMap) : super.fromMap();
  
  // Mapeig
  @override
  void fromMap(LdMap<dynamic> pMap) {
    super.fromMap(pMap);
    
    // Carregar propietats del model (mf)
    _text = pMap[mfInitialText] as String? ?? "";
    _label.t = pMap[mfLabel] as String?;
    _helpText.t = pMap[mfHelpText] as String?;
    _errorMessage.t = pMap[mfErrorMessage] as String?;
    _hasError = pMap[mfHasError] as bool? ?? false;
    _allowNull = pMap[mfAllowNull] as bool? ?? true;
    
    // Carregar callback si existeix (cf)
    _onTextChanged = pMap[cfOnTextChanged] as Function(String)?;
    
    Debug.info("$tag: Model carregat des de mapa");
  }
  
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfText: _text,
      mfLabel: _label.t,
      mfHelpText: _helpText.t,
      mfErrorMessage: _errorMessage.t,
      mfHasError: _hasError,
      mfAllowNull: _allowNull,
      // No guardem el callback al mapa ja que no és serialitzable
    });
    return map;
  }
  
  @override
  dynamic getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfText: return text;
      case mfLabel: return label;
      case mfHelpText: return helpText;
      case mfErrorMessage: return errorMessage;
      case mfHasError: return hasError;
      case mfAllowNull: return allowNull;
      default: return super.getField(
        pKey: pKey, 
        pCouldBeNull: pCouldBeNull, 
        pErrorMsg: pErrorMsg
      );
    }
  }
  
  @override
  void setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case mfText: 
        if (pValue is String) text = pValue;
        break;
      case mfLabel: 
        if (pValue is String || pValue == null) label = pValue;
        break;
      case mfHelpText: 
        if (pValue is String || pValue == null) helpText = pValue;
        break;
      case mfErrorMessage: 
        if (pValue is String || pValue == null) errorMessage = pValue;
        break;
      case mfHasError: 
        if (pValue is bool) hasError = pValue;
        break;
      case mfAllowNull: 
        if (pValue is bool) allowNull = pValue;
        break;
      default: 
        super.setField(
          pKey: pKey, 
          pValue: pValue, 
          pCouldBeNull: pCouldBeNull, 
          pErrorMsg: pErrorMsg
        );
    }
  }
  
  // Validació
  bool validate() {
    if (!allowNull && _text.isEmpty) {
      hasError = true;
      errorMessage = "Aquest camp és obligatori";
      return false;
    }
    
    // Neteja l'error si la validació passa
    hasError = false;
    errorMessage = null;
    
    return true;
  }
  
  // Netejar el text i l'estat d'error
  void clear() {
    notifyListeners(() {
      _text = "";
      _hasError = false;
      _errorMessage.t = null;
      Debug.info("$tag: Model netejat");
    });
  }
}