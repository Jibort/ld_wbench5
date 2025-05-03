// ld_app_bar_ctrl.dart
// Controlador del widget LdAppBar.
// CreatedAt: 2025-05-01 dc. JIQ

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdAppBar.
class   LdAppBarCtrl
extends LdWidgetCtrlAbs<LdAppBar> {
  /// Accions de la barra d'aplicació
  final List<Widget>? actions;
  
  /// Constructor
  LdAppBarCtrl(super.pWidget, { this.actions });
  
  /// Accelerador d'accés al model.
  LdAppBarModel get model => cWidget.wModel as LdAppBarModel;

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador de la AppBar");
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void onEvent(LdEvent pEvent) {
    // Gestionar events específics si cal
  }
  
  @override
  Widget buildContent(BuildContext context) {
    return (model.subTitle != null)
      ? AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.title),
              Text(model.subTitle!),
            ],
          ),
          actions: actions,
        )
      : AppBar(
        title: Text(model.title),
        actions: actions,
      );
  }
}


