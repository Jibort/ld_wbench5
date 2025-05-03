// lib/ui/widgets/sabina_scaffold.dart
// Scaffold personalitzat de Sabina
// Created: 2025/04/29 DT. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold_ctrl.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Scaffold personalitzat de Sabina
class LdScaffold extends LdWidgetAbs {
  /// Constructor
  LdScaffold({
    super.key,
    super.pTag,
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    Widget? drawer,
  }) { 
    // Crear un model buit només per no provocar excepcions
    wModel = LdScaffoldModel(this);
    
    // Assignar el controlador
    wCtrl = LdScaffoldCtrl(this,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    );
    
    Debug.info("$tag: Scaffold creat");
  }
}