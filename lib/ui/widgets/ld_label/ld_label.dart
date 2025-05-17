// lib/ui/widgets/ld_label/ld_label.dart
// Widget d'etiqueta amb suport per a traducció i interpolació
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/15 dj. GPT(JIQ)

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_ctrl.dart';

/// Widget d'etiqueta amb suport per a traducció i interpolació
class LdLabel extends LdWidgetAbs {
  // CONSTRUCTOR ==========================================
  LdLabel({
    Key? key,
    super.pTag,
    String? pLabel,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    bool? softWrap,
    Strings? pPosArgs,
    LdMap<String>? pNamedArgs,
    bool isVisible = true,
  }) : super(
          pKey: key,
          pConfig: {
            cfIsVisible: isVisible,
            cfLabel: pLabel ?? '',
            cfLabelStyle: style,
            cfLabelTextAlign: textAlign,
            cfLabelOverflow: overflow,
            cfLabelMaxLines: maxLines,
            cfLabelSoftWrap: softWrap,
            cfLabelPosArgs: pPosArgs,
            cfLabelNamedArgs: pNamedArgs,
          },
        ) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: LdLabel creat amb text '$pLabel'");
  }

  /// Constructor a partir d'un mapa de configuració
  LdLabel.fromMap(MapDyns configMap) : super(pConfig: configMap);

  // CONTROLADOR ==========================================
  @override
  LdLabelCtrl createCtrl() => LdLabelCtrl(this);

  /// Accés al model amb tipus segur
  LdLabelCtrl? get wCtrl => ctrl as LdLabelCtrl?;

  // MÈTODES D'ACTUALITZACIÓ ==============================
  /// Actualitza només els arguments de traducció, sense reconstruir el parent
  void setTranslationArgsIsolated({
    List<String>? positionalArgs,
    LdMap<String>? namedArgs,
  }) {
    (ctrl as LdLabelCtrl?)?.updateTranslationParametersOnly(
      positionalArgs,
      namedArgs,
    );
  }
  
  /// Assigna arguments de traducció
  void setTranslationArgs({
    Strings? positionalArgs,
    LdMap<String>? namedArgs,
  }) => wCtrl?.updateTranslationParams(
        positionalArgs: positionalArgs,
        namedArgs: namedArgs,
      );

  /// Actualitza el text dinàmicament
  void setLabel(String pNewLabel) => wCtrl?.updateLabel(pNewLabel);

  /// Actualitza l'estil del text
  void setStyle(TextStyle? newStyle) => wCtrl?.updateLabelStyle(newStyle);

  /// Obté l'estil del text actual
  TextStyle? get currentTextStyle => wCtrl?.getCurrentLabelStyle();
}
