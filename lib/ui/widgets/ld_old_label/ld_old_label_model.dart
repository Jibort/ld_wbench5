// lib/ui/widgets/ld_label/ld_label_model.dart
// Model del widget LdOldLabel
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/15 dj. GPT(JIQ)
// Fixed: 2025/05/16 dv. - Correccions per mantenir clau de traducció

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/services/L.dart';

/// Model del widget LdOldLabel
class   LdOldLabelModel 
extends LdModelAbs {
  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor principal
  LdOldLabelModel({
    String? pTag,
    String? pLabel,
    TextStyle? pStyle,
    List<String>? pPosArgs,
    LdMap<String>? pNamedArgs,
  }) {
    tag = pTag ?? generateTag();
    
    // Inicialitzar camps
    setField(pKey: cfLabel, pValue: pLabel ?? '');
    if (pStyle != null) setField(pKey: cfLabelStyle, pValue: pStyle);
    if (pPosArgs != null) setField(pKey: cfLabelPosArgs, pValue: pPosArgs);
    if (pNamedArgs != null) setField(pKey: cfLabelNamedArgs, pValue: pNamedArgs);
  }

  /// Constructor des de mapa
  LdOldLabelModel.fromMap(MapDyns pMap) {
    fromMap(pMap);
  }

  // GETTERS/SETTERS ======================================
  TextStyle? get labelStyle => getField(pKey: cfLabelStyle);
  set labelStyle(TextStyle? pStyle) 
  => setField(pKey: cfLabelStyle, pValue: pStyle);

  TextAlign? get textAlign => getField(pKey: cfLabelTextAlign);
  TextOverflow? get overflow => getField(pKey: cfLabelOverflow);
  int? get maxLines => getField(pKey: cfLabelMaxLines);
  bool? get softWrap => getField(pKey: cfLabelSoftWrap);

  Strings get positionalArgs => getField(pKey: cfLabelPosArgs) ?? [];
  set positionalArgs(Strings pArgs) => setField(pKey: cfLabelPosArgs, pValue: pArgs);

  MapStrings get namedArgs => getField(pKey: cfLabelNamedArgs) ?? {};
  set namedArgs(MapStrings pArgs) => setField(pKey: cfLabelNamedArgs, pValue: pArgs);

  // Getter/Setter per al text base
  String get baseText => getField(pKey: cfLabel) ?? '';
  set baseText(String value) {
    setField(pKey: cfLabel, pValue: value);
  }

  /// Text traduït i interpolat.
  String get label 
  => StringTx.resolveText(baseText, positionalArgs, namedArgs);

  /// Estableix el text de l'etiqueta amb els arguments necessaris.
  set label(String pNewLabel) {
    baseText = pNewLabel;
  }

  /// Permet carregar l'estat de l'etiqueta a partir d'un mapa.
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap);
    
    // Carregar tots els camps possibles
    if (pMap.containsKey(cfLabel)) setField(pKey: cfLabel, pValue: pMap[cfLabel]);
    if (pMap.containsKey(cfLabelStyle)) setField(pKey: cfLabelStyle, pValue: pMap[cfLabelStyle]);
    if (pMap.containsKey(cfLabelPosArgs)) setField(pKey: cfLabelPosArgs, pValue: pMap[cfLabelPosArgs]);
    if (pMap.containsKey(cfLabelNamedArgs)) setField(pKey: cfLabelNamedArgs, pValue: pMap[cfLabelNamedArgs]);
    if (pMap.containsKey(cfLabelTextAlign)) setField(pKey: cfLabelTextAlign, pValue: pMap[cfLabelTextAlign]);
    if (pMap.containsKey(cfLabelOverflow)) setField(pKey: cfLabelOverflow, pValue: pMap[cfLabelOverflow]);
    if (pMap.containsKey(cfLabelMaxLines)) setField(pKey: cfLabelMaxLines, pValue: pMap[cfLabelMaxLines]);
    if (pMap.containsKey(cfLabelSoftWrap)) setField(pKey: cfLabelSoftWrap, pValue: pMap[cfLabelSoftWrap]);
  }

  /// Mètode per actualitzar arguments sense perdre el text base.
  void updateTranslationArgs({
    List<String>? positionalArgs,
    LdMap<String>? namedArgs,
  }) {
    notifyListeners(() {
      if (positionalArgs != null) setField(pKey: cfLabelPosArgs, pValue: positionalArgs);
      if (namedArgs != null) setField(pKey: cfLabelNamedArgs, pValue: namedArgs);
    });
  }
}

// /// Model per al widget LdOldLabel
// class LdOldLabelModel extends LdWidgetModelAbs {
//   // CONSTRUCTOR ==========================================
//   LdOldLabelModel({required MapDyns config}) : super.fromMap(config);
//   // ignore: use_super_parameters
//   LdOldLabelModel.fromMap(MapDyns map) : super.fromMap(map);
//
//   // MEMBRES ==============================================
//   TextStyle? get labelStyle => config[cfLabelStyle] as TextStyle?;
//   set labelStyle(TextStyle? pStyle) => config[cfLabelStyle] = pStyle;
//
//   TextAlign? get textAlign => config[cfLabelTextAlign] as TextAlign?;
//   TextOverflow? get overflow => config[cfLabelOverflow] as TextOverflow?;
//   int? get maxLines => config[cfLabelMaxLines] as int?;
//   bool? get softWrap => config[cfLabelSoftWrap] as bool?;
//
//   List<String> get positionalArgs => config[cfLabelPosArgs] as List<String>? ?? [];
//   set positionalArgs(List<String> args) {
//     config[cfLabelPosArgs] = args;
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: positionalArgs actualitzats a: $args");
//   }
//
//   LdMap<String> get namedArgs => config[cfLabelNamedArgs] as LdMap<String>? ?? const {};
//   set namedArgs(LdMap<String> args) {
//     config[cfLabelNamedArgs] = args;
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: namedArgs actualitzats a: $args");
//   }
//
//   // TEXT BASE I INTERPOLACIÓ =========================
//   /// Obté el text base (clau de traducció o text literal)
//   String get baseText => config[cfLabel] as String? ?? '';
//  
//   /// Obté el text final amb interpolació aplicada
//   String get label {
//     final base = baseText;
//     final result = StringTx.resolveText(base, positionalArgs, namedArgs);
//    
//     // Debug detallat
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag.label:");
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("  - Base text: '$base'");
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("  - Positional args: $positionalArgs");
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("  - Named args: $namedArgs");
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("  - Result: '$result'");
//    
//     return result;
//   }
//  
//   /// Actualitza el text base (clau o literal)
//   set label(String pLabel) {
//     config[cfLabel] = pLabel;
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Text base actualitzat a: '$pLabel'");
//   }
//
//   // MÈTODES AUXILIARS ===============================
//   /// Actualitza arguments sense perdre el text base
//   void updateTranslationArgs({
//     List<String>? positionalArgs,
//     LdMap<String>? namedArgs,
//   }) {
//     if (positionalArgs != null) {
//       this.positionalArgs = positionalArgs;
//     }
//     if (namedArgs != null) {
//       this.namedArgs = namedArgs;
//     }
//    
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Arguments d'interpolació actualitzats");
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("  - Text base conservat: '$baseText'");
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("  - Nous args posicionals: $positionalArgs");
//     //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("  - Nous args nomenats: $namedArgs");
//   }
// }