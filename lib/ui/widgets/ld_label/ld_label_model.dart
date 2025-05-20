// lib/ui/widgets/ld_label/ld_label_model.dart
// Model de dades per al widget LdLabel
// Created: 2025/05/20 dl. CLA

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';

class LdLabelModel extends LdModelAbs {
  LdLabelModel({
    String? label,
    List<String>? positionalArgs,
    MapStrings? namedArgs,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    bool? softWrap,
  }) : super({}) {
    // Actualitzat amb paràmetres amb nom
    if (label != null) setField(pKey: cfLabel, pValue: label);
    if (positionalArgs != null) setField(pKey: cfLabelPosArgs, pValue: positionalArgs);
    if (namedArgs != null) setField(pKey: cfLabelNamedArgs, pValue: namedArgs);
    if (style != null) setField(pKey: cfLabelStyle, pValue: style);
    if (textAlign != null) setField(pKey: cfLabelTextAlign, pValue: textAlign);
    if (overflow != null) setField(pKey: cfLabelOverflow, pValue: overflow);
    if (maxLines != null) setField(pKey: cfLabelMaxLines, pValue: maxLines);
    if (softWrap != null) setField(pKey: cfLabelSoftWrap, pValue: softWrap);
  }

  @override
  void fromMap(MapDyns pMap) {
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
  }

  void updateTranslationArgs({
    List<String>? positionalArgs,
    MapStrings? namedArgs,
  }) {
    notifyListeners(() {
      if (positionalArgs != null) setField(pKey: cfLabelPosArgs, pValue: positionalArgs);
      if (namedArgs != null) setField(pKey: cfLabelNamedArgs, pValue: namedArgs);
    });
  }
}