// lib/ui/widgets/sabina_button.dart
// Botó personalitzat de Sabina
// Created: 2025/04/29 DT. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Botó personalitzat de Sabina
class SabinaButton extends LdWidget {
  /// Constructor
  SabinaButton({
    super.key,
    required String text,
    VoidCallback? onPressed,
    Color? backgroundColor,
  }) : super(
    pTag: 'SabinaButton',
    ctrl: SabinaButtonCtrl(
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
    ),
  );
}

/// Controlador per al SabinaButton
class SabinaButtonCtrl extends LdWidgetCtrl<SabinaButton> {
  /// Text del botó
  final String text;
  
  /// Callback quan es prem el botó
  final VoidCallback? onPressed;
  
  /// Color de fons personalitzat
  final Color? backgroundColor;
  
  /// Constructor
  SabinaButtonCtrl({
    required this.text,
    this.onPressed,
    this.backgroundColor,
  });
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador del botó");
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
    return ElevatedButton(
      onPressed: onPressed,
      style: backgroundColor != null 
        ? ElevatedButton.styleFrom(backgroundColor: backgroundColor) 
        : null,
      child: Text(text),
    );
  }
}