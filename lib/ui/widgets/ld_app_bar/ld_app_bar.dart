// lib/ui/widgets/ld_app_bar.dart
// Widget de la barra d'aplicació personalitzada
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/05 dl. CLA - Millora del suport d'internacionalització

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

export 'ld_app_bar_ctrl.dart';
export 'ld_app_bar_model.dart';

/// Widget de la barra d'aplicació personalitzada
class LdAppBar 
extends LdWidgetAbs {
  /// Constructor
  LdAppBar({
    super.key,
    super.pTag, 
    required String pTitleKey,
    String? pSubTitleKey,
    List<Widget>? actions,
  }) { 
    Debug.info("$tag: Creant LdAppBar amb títol '$pTitleKey' i subtítol '$pSubTitleKey'");
    
    // Crear primer el model amb les claus o textos literals
    wModel = LdAppBarModel(
      this,
      pTitleKey: pTitleKey, 
      pSubTitleKey: pSubTitleKey
    );
    
    // Després el controlador amb les accions opcionals
    wCtrl = LdAppBarCtrl(
      this,
      actions: actions
    );
    
    Debug.info("$tag: LdAppBar creat correctament");
  }
  
  /// Constructor alternatiu que accepta directament objectes StringTx
  LdAppBar.fromStringTx({
    super.key,
    super.pTag,
    required StringTx pTitle,
    StringTx? pSubTitle,
    List<Widget>? actions,
  }) {
    Debug.info("$tag: Creant LdAppBar des de StringTx amb clau de títol '${pTitle.key}'");
    
    // Passar les claus de traducció o textos literals
    wModel = LdAppBarModel(
      this,
      pTitleKey: pTitle.key ?? pTitle.literalText ?? "",
      pSubTitleKey: pSubTitle?.key ?? pSubTitle?.literalText
    );
    
    // Després el controlador amb les accions opcionals
    wCtrl = LdAppBarCtrl(
      this,
      actions: actions
    );
    
    Debug.info("$tag: LdAppBar creat correctament des de StringTx");
  }
}