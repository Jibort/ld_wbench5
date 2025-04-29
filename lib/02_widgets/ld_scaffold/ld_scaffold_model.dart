// ld_scaffold_model.dart
// Model de dades pel widget 'LdScaffold'.
// CreatedAt: 2025/04/18 dv. JIQ

import 'dart:convert';

import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_model_abs.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Model de dades pel widget 'LdScaffold'.
/// Model de dades del widget LdButton.
class   LdScaffoldModel
extends LdWidgetModelAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdScaffoldModel";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdScaffoldModel({ 
    required super.pView, 
    required super.pWidget });

  @override
  LdMap toMap() => LdMap(pMap: {
    mfTag: tag
  });

  @override
  void fromMap(LdMap pMap) => tag = pMap[mfTag]?? "!?";

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  // 📍 'LdTagMixin': Retorna el tab base per defecte de la classe.
  @override String baseTag() => LdScaffoldModel.className;
  
  /// Retorna el valor d'un component donat o null.
  @override
  dynamic getField(String pField) 
  => null;


  /// Estableix el valor d'un component donat del model.
  @override
  void setField(String pField, dynamic pValue) {}
    
  @override
  void fromJson(String pJSon) => fromMap(LdMap(pMap: jsonDecode(pJSon)));
    
  @override
  String toJson() => jsonEncode(toMap);

  @override String modelName() => "wmnLdButton";
}
