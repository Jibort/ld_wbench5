// lib/ui/widgets/ld_text_field/ld_text_field_model.dart
// Model de dades del widget 'LdTextField'.
// Created: 2025/05/06 dt. CLA

import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';

/// Model de dades del widget LdTextField
class LdTextFieldModel extends LdWidgetModelAbs<LdTextField> {
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
  String get label => _label.tx ?? "";
  set label(String value) {
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
  
  // Constructor
  LdTextFieldModel(
    super.pWidget, 
    {
      String initialText = "",
      String? label,
      String? helpText,
      String? errorMessage,
      bool hasError = false,
      bool allowNull = true,
      Function(String)? onTextChanged,
    }
  ) {
    _text = initialText;
    _label.t = label;
    _helpText.t = helpText;
    _errorMessage.t = errorMessage;
    _hasError = hasError;
    _allowNull = allowNull;
    _onTextChanged = onTextChanged;
  }
  
  // Mapeig
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      'text': _text,
      'label': _label.t,
      'helpText': _helpText.t,
      'errorMessage': _errorMessage.t,
      'hasError': _hasError,
      'allowNull': _allowNull,
    });
    return map;
  }
  
  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    _text = pMap['text'] as String? ?? "";
    _label.t = pMap['label'] as String?;
    _helpText.t = pMap['helpText'] as String?;
    _errorMessage.t = pMap['errorMessage'] as String?;
    _hasError = pMap['hasError'] as bool? ?? false;
    _allowNull = pMap['allowNull'] as bool? ?? true;
  }
  
  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    switch (pKey) {
      case 'text': return text;
      case 'label': return label;
      case 'helpText': return helpText;
      case 'errorMessage': return errorMessage;
      case 'hasError': return hasError;
      case 'allowNull': return allowNull;
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
      case 'text': 
        if (pValue is String) text = pValue;
        break;
      case 'label': 
        if (pValue is String || pValue == null) label = pValue;
        break;
      case 'helpText': 
        if (pValue is String || pValue == null) helpText = pValue;
        break;
      case 'errorMessage': 
        if (pValue is String || pValue == null) errorMessage = pValue;
        break;
      case 'hasError': 
        if (pValue is bool) hasError = pValue;
        break;
      case 'allowNull': 
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
}