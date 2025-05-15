// lib/ui/widgets/ld_label/ld_label_model.dart
// Model del widget LdLabel
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/15 dj. GPT(JIQ)

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/L10n/string_tx.dart';

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
  set positionalArgs(List<String> args) => config[cfLabelPosArgs] = args;

  LdMap<String> get namedArgs => config[cfLabelNamedArgs] as LdMap<String>? ?? const {};
  set namedArgs(LdMap<String> args) => config[cfLabelNamedArgs] = args;

  String get label => StringTx.resolveText((config[cfLabel] as String? ?? ''), positionalArgs, namedArgs);
  set label(String pLabel) => config[cfLabel] = pLabel;

  // JIQ_8: // TRADUCCIÓ ============================================
  // String get translatedText
  // => StringTx.resolveText(text, positionalArgs, namedArgs);
}