// lib/ui/widgets/ld_text/ld_text.dart
// Widget de text que suporta internacionalització automàtica
// Created: 2025/05/06 dt. CLA

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/services/maps_service.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_ctrl.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Widget Label personalitzat
/// 
/// Hereta de [LdWidgetAbs] per utilitzar l'arquitectura unificada
/// amb GlobalKey i LdTaggableMixin.
/// 
/// Tota la lògica està al [LdLabelCtrl].
class   LdLabel 
extends LdWidgetAbs {
  LdLabel({
    Key? key,  
    super.pTag,
    String text = '',
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  })
  : super(pKey: key) 
  { // Configurar tots els camps
    final map = <String, dynamic>{
      cfTextStyle: style,
      cfTextAlign: textAlign,
      cfTextDirection: textDirection,
      cfLocale: locale,
      cfSoftWrap: softWrap,
      cfOverflow: overflow,
      cfTextWidthBasis: textWidthBasis,
      cfTextHeightBehavior: textHeightBehavior,
      cfSemanticLabel: semanticsLabel,
      cfSelectionColor: selectionColor,
      
      // Camps adicionals
      if (strutStyle != null) 'cf_strut_style': strutStyle,
      if (textScaleFactor != null) 'cf_text_scale_factor': textScaleFactor,
      if (textScaler != null) 'cf_text_scaler': textScaler,
      if (maxLines != null) 'cf_max_lines': maxLines,
      
      // Dada del model
      mfText: text,
    };
    
    MapsService.s.updateMap(tag, map);
  }

  /// Constructor alternatiu a partir d'un mapa
  LdLabel.fromMap(LdMap<dynamic> pConfig)
  : super(pConfig: pConfig) {
    Debug.info("$tag: LdTextField creat des d'un mapa");
  }

  @override
  LdLabelCtrl createCtrl() => LdLabelCtrl(this);

  // ACCESSORS PER A COMPATIBILITAT
  LdLabelModel? get model {
    final ctrl = wCtrl;
    if (ctrl is LdLabelCtrl) {
      return ctrl.model as LdLabelModel?;
    }
    return null;
  }

  LdLabelCtrl? get controller =>
    (wCtrl is LdLabelCtrl)
      ? wCtrl as LdLabelCtrl
      : null;

  // PROPIETATS DEL MODEL
  String get text => model?.text ?? "";
  set text(String value) {
    model?.updateField(mfText, value);
  }

}