// lib/ui/widgets/sabina_scaffold.dart
// Scaffold personalitzat de Sabina
// Created: 2025/04/29 DT. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Scaffold personalitzat de Sabina
class SabinaScaffold extends LdWidget {
  /// Constructor
  SabinaScaffold({
    super.key,
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    Widget? drawer,
  }) : super(
    pTag: 'SabinaScaffold',
    ctrl: SabinaScaffoldCtrl(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    ),
  );
}

/// Controlador per al SabinaScaffold
class SabinaScaffoldCtrl extends LdWidgetCtrl<SabinaScaffold> {
  /// Barra superior
  final PreferredSizeWidget? appBar;
  
  /// Contingut principal
  final Widget body;
  
  /// Botó flotant
  final Widget? floatingActionButton;
  
  /// Menú lateral
  final Widget? drawer;
  
  /// Constructor
  SabinaScaffoldCtrl({
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
  void onEvent(LdEvent event) {
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