// lib/ui/widgets/sabina_scaffold.dart
// Scaffold personalitzat de Sabina
// Created: 2025/04/29 DT. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold_ctrl.dart';

/// Scaffold personalitzat de Sabina
class   LdScaffold 
extends LdWidgetAbs {
  /// Constructor
  LdScaffold({
    super.key,
    super.pTag,
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    Widget? drawer,
  })
  { wCtrl = LdScaffoldCtrl(this,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    );
  }
}
