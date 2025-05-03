// ld_scaffold_ctrl.dart
// Controlador del widget LdScaffold.
// CreatedAt: 2025/05/03 ds. JIQ

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador per al SabinaScaffold
class LdScaffoldCtrl extends LdWidgetCtrlAbs<LdScaffold> {
  /// Barra superior
  final PreferredSizeWidget? appBar;
  
  /// Contingut principal
  final Widget body;
  
  /// Botó flotant
  final Widget? floatingActionButton;
  
  /// Menú lateral
  final Widget? drawer;
  
  /// Constructor
  LdScaffoldCtrl(super.pWidget, {
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.drawer,
  });
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador del scaffold");
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
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    );
  }
}