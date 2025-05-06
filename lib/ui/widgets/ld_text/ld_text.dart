// lib/ui/widgets/ld_text/ld_text.dart
// Widget de text que suporta internacionalització automàtica
// Created: 2025/05/06 dt. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_text/ld_text_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_text/ld_text_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_text_ctrl.dart';
export 'ld_text_model.dart';

/// Widget de text que suporta internacionalització automàtica
class LdText extends LdWidgetAbs {
  /// Constructor
  LdText({
    super.key,
    super.pTag,
    required String text,
    List<dynamic>? args,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    Debug.info("$tag: Creant LdText amb text '$text'");
    
    // Crear primer el model amb el text i els arguments
    wModel = LdTextModel(
      this,
      text: text, 
      args: args
    );
    
    // Després el controlador amb les propietats d'estil
    wCtrl = LdTextCtrl(
      this,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow
    );
    
    Debug.info("$tag: LdText creat correctament");
  }
}