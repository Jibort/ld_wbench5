// lib/ui/widgets/sabina_app_bar.dart
// Widget de la barra d'aplicació personalitzada
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Widget de la barra d'aplicació personalitzada
class SabinaAppBar extends LdWidget {
  /// Constructor
  SabinaAppBar({
    super.key, 
    String? title,
    List<Widget>? actions,
  }) : super(
    pTag: 'SabinaAppBar',
    ctrl: SabinaAppBarCtrl(
      title: title,
      actions: actions,
    ),
  );
}

/// Controlador per al SabinaAppBar
class SabinaAppBarCtrl extends LdWidgetCtrl<SabinaAppBar> {
  /// Títol de la barra d'aplicació
  final String? title;
  
  /// Accions de la barra d'aplicació
  final List<Widget>? actions;
  
  /// Constructor
  SabinaAppBarCtrl({
    this.title,
    this.actions,
  });
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador de la AppBar");
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void onEvent(LdEvent event) {
    // Gestionar events específics si cal
  }
  
  @override
  Widget buildContent(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      actions: actions,
    );
  }
}