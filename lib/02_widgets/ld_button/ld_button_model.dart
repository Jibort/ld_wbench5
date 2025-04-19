// ld_button_model.dart
// Model de dades del widget 'LdButton'.
// CreatedAt: 2025/04/18 dv. JIQ

import 'dart:convert';

import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/full_set.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Model de dades del widget 'LdButton'.
class   LdButtonModel
extends LdWidgetModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdButtonModel";
  
  // 🧩 MEMBRES ------------------------
  final FullSet<String?> _text = FullSet<String?>();

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdButtonModel({ 
    required super.pView, 
    required super.pWidget, 
    super.pTag,
    required String? pText }) {
    _text.set(pText);
  }

  @override
  LdMap toMap() => LdMap(pMap: {
    mfText: _text.get(),
  });

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna el text del butó.
  String? get text => _text.get();
  /// Estableix el text del butó.
  set text(String? pText)
  => (text != pText) ? wCtrl.setState(() => text = pText): null;

  @override
  void fromMap(LdMap pMap) {
    _text.set(pMap[mfText]);
  }

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  // 📍 'LdTagMixin': Retorna el tab base per defecte de la classe.
  @override String baseTag() => LdButtonModel.className;
  
  /// Retorna el valor d'un component donat o null.
  @override
  dynamic getField(String pField) 
  => (pField == mfText)
   ? _text.get()
   : null;


  /// Estableix el valor d'un component donat del model.
  @override
  void setField(String pField, dynamic pValue) 
  => (pField == mfText)
    ? wCtrl.setState(() { _text.set(pValue); })
    : null;
    
  @override
  void fromJson(String pJSon) => fromMap(LdMap(pMap: jsonDecode(pJSon)));
    
  @override
  String toJson() => jsonEncode(toMap);

  @override String modelName() => "wmnLdButton";
}

