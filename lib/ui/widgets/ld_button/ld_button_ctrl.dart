// ld_button_ctrl.dart
// Controlador pel widget LdButton.
// CreatedAt: 2025/05/01 dc. JIQ

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador pel widget LdButton.
class   LdButtonCtrl
extends LdWidgetCtrlAbs<LdButton> {
  /// Retorna el model del widget.
  LdButtonModel get model => widget.wModel as LdButtonModel;

  /// Callback quan es prem el botó
  final VoidCallback? onPressed;
  
  /// Color de fons personalitzat
  final Color? backgroundColor;
  
  /// Constructor
  LdButtonCtrl(
    super.pWidget, {
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
  void onEvent(LdEvent pEvent) {
    // Gestionar events específics si cal
  }
  
  @override
  Widget buildContent(BuildContext context) {
    String text = (model.text == null && model.iconData == null)? errInText : model.text ?? errInText;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: backgroundColor != null 
        ? ElevatedButton.styleFrom(backgroundColor: backgroundColor) 
        : null,
      child: Text(text),
    );
  }
}
