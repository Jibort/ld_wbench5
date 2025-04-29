// ld_test_01_model_abs.dart
// Model de dades per a la pàgina de proves 'LdTest01'.
// CreatedAt: 2025/02/08 dt. JIQ

import 'dart:convert';

import 'package:ld_wbench5/10_tools/ld_map.dart';

import 'package:ld_wbench5/03_core/views/ld_view_model_abs.dart';
import 'package:ld_wbench5/09_intl/L.dart';

/// Model de dades per a la pàgina de proves 'LdTest01'.
class   LdTest01Model
extends LdViewModelAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdTest01Model";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdTest01Model({
    required super.pView,
    super.pTag,
    String? pTitle,
    String? pSubtitle})
  : super(
      pTitle:    pTitle??    L.sAppSabina.tx, 
      pSubTitle: pSubtitle?? L.sWelcome.tx
    );

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 📍 'LdTagMixin': Retorna la base del model de la pàgina 'LdTest01'.
  @override String baseTag() => LdTest01Model.className;
  
    
  /// 📍 '...': Informa els membres de la instància amb els valors del mapa proporcionat.
  @override
  void fromJson(String pJSon) => fromMap(LdMap(pMap: jsonDecode(pJSon)));

  @override String modelName() => baseTag();

  @override String toJson() => jsonEncode(toMap);
}