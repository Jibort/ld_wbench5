// lib/ui/widgets/ld_label/ld_label_model.dart
// Model del widget LdLabel
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/15 dj. GPT(JIQ)
// Fixed: 2025/05/16 dv. - Correccions per mantenir clau de traducció

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Model per al widget LdLabel
class LdLabelModel extends LdWidgetModelAbs {
  // CONSTRUCTOR ==========================================
  LdLabelModel({required MapDyns config}) : super.fromMap(config);
  // ignore: use_super_parameters
  LdLabelModel.fromMap(MapDyns map) : super.fromMap(map);
  
  // MEMBRES ==============================================
  TextStyle? get labelStyle => config[cfLabelStyle] as TextStyle?;
  set labelStyle(TextStyle? pStyle) => config[cfLabelStyle] = pStyle;

  TextAlign? get textAlign => config[cfLabelTextAlign] as TextAlign?;
  TextOverflow? get overflow => config[cfLabelOverflow] as TextOverflow?;
  int? get maxLines => config[cfLabelMaxLines] as int?;
  bool? get softWrap => config[cfLabelSoftWrap] as bool?;

  List<String> get positionalArgs => config[cfLabelPosArgs] as List<String>? ?? [];
  set positionalArgs(List<String> args) {
    config[cfLabelPosArgs] = args;
    Debug.info("$tag: positionalArgs actualitzats a: $args");
  }

  LdMap<String> get namedArgs => config[cfLabelNamedArgs] as LdMap<String>? ?? const {};
  set namedArgs(LdMap<String> args) {
    config[cfLabelNamedArgs] = args;
    Debug.info("$tag: namedArgs actualitzats a: $args");
  }

  // TEXT BASE I INTERPOLACIÓ =========================
  /// Obté el text base (clau de traducció o text literal)
  String get baseText => config[cfLabel] as String? ?? '';
  
  /// Obté el text final amb interpolació aplicada
  String get label {
    final base = baseText;
    final result = StringTx.resolveText(base, positionalArgs, namedArgs);
    
    // Debug detallat
    Debug.info("$tag.label:");
    Debug.info("  - Base text: '$base'");
    Debug.info("  - Positional args: $positionalArgs");
    Debug.info("  - Named args: $namedArgs");
    Debug.info("  - Result: '$result'");
    
    return result;
  }
  
  /// Actualitza el text base (clau o literal)
  set label(String pLabel) {
    config[cfLabel] = pLabel;
    Debug.info("$tag: Text base actualitzat a: '$pLabel'");
  }

  // MÈTODES AUXILIARS ===============================
  /// Actualitza arguments sense perdre el text base
  void updateTranslationArgs({
    List<String>? positionalArgs,
    LdMap<String>? namedArgs,
  }) {
    if (positionalArgs != null) {
      this.positionalArgs = positionalArgs;
    }
    if (namedArgs != null) {
      this.namedArgs = namedArgs;
    }
    
    Debug.info("$tag: Arguments d'interpolació actualitzats");
    Debug.info("  - Text base conservat: '$baseText'");
    Debug.info("  - Nous args posicionals: $positionalArgs");
    Debug.info("  - Nous args nomenats: $namedArgs");
  }
}