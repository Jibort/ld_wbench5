// lib/ui/widgets/ld_label/ld_label.dart
// Widget d'etiqueta amb suport per a traducció i interpolació
// Created: 2025/05/20 dl. CLA
// Updated: 2025/05/20 dl. CLA - Inici de nova implementació

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_old_label/ld_old_label_ctrl.dart';

export 'package:ld_wbench5/ui/widgets/ld_label/ld_label_ctrl.dart';
export 'package:ld_wbench5/ui/widgets/ld_label/ld_label_model.dart';


/// Widget d'etiqueta amb suport per a traducció i interpolació
class LdLabel extends LdWidgetAbs {
  /// Constructor principal
  LdLabel({
    Key? key,
    required String pLabel,
    List<String>? pPosArgs,
    MapStrings? pNamedArgs,
    TextStyle? pStyle,
    TextAlign? pTextAlign,
    TextOverflow? pOverflow,
    int? pMaxLines,
    bool? pSoftWrap,
  }) : super(
          pKey: key,
          pConfig: {
            cfLabel: pLabel,
            cfLabelPosArgs: pPosArgs,
            cfLabelNamedArgs: pNamedArgs,
            cfLabelStyle: pStyle,
            cfLabelTextAlign: pTextAlign,
            cfLabelOverflow: pOverflow,
            cfLabelMaxLines: pMaxLines,
            cfLabelSoftWrap: pSoftWrap,
          },
        );

  /// Constructor alternatiu a partir d'un mapa de configuració
  @override
  MapDyns fromMap(MapDyns pMap) {
    super.fromMap(pMap);
    
    // Actualitzat amb paràmetres amb nom
    if (pMap.containsKey(cfLabel)) setField(pKey: cfLabel, pValue: pMap[cfLabel]);
    if (pMap.containsKey(cfLabelPosArgs)) setField(pKey: cfLabelPosArgs, pValue: pMap[cfLabelPosArgs]);
    if (pMap.containsKey(cfLabelNamedArgs)) setField(pKey: cfLabelNamedArgs, pValue: pMap[cfLabelNamedArgs]);
    if (pMap.containsKey(cfLabelStyle)) setField(pKey: cfLabelStyle, pValue: pMap[cfLabelStyle]);
    if (pMap.containsKey(cfLabelTextAlign)) setField(pKey: cfLabelTextAlign, pValue: pMap[cfLabelTextAlign]);
    if (pMap.containsKey(cfLabelOverflow)) setField(pKey: cfLabelOverflow, pValue: pMap[cfLabelOverflow]);
    if (pMap.containsKey(cfLabelMaxLines)) setField(pKey: cfLabelMaxLines, pValue: pMap[cfLabelMaxLines]);
    if (pMap.containsKey(cfLabelSoftWrap)) setField(pKey: cfLabelSoftWrap, pValue: pMap[cfLabelSoftWrap]);
    
    return pMap; // Retornar el mapa
  }

  // Constructor des de mapa (ara cridarà fromMap)
  LdLabelModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
    fromMap(pMap); // Ara cridem fromMap amb el mapa
  }
  /// Crear el controlador associat
  @override
  LdOldLabelCtrl createCtrl() => LdLabelCtrl(this);
}