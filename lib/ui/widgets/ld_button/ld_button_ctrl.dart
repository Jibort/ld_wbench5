// lib/ui/widgets/ld_button/ld_button_ctrl.dart
// Controlador pel widget LdButton.
// Actualitzat amb gestió de visibilitat, focus i estat actiu.
// CreatedAt: 2025/05/01 dc. JIQ
// Updated: 2025/05/03 ds.

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
    super.isVisible = true,
    super.canFocus = true,
    super.isEnabled = true,
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
    String text = (model.text == null && model.iconData == null) ? errInText : model.text ?? errInText;
    
    // Determinar si el botó està actiu
    final VoidCallback? effectiveOnPressed = isEnabled ? onPressed : null;
    
    // Crear el botó amb el focusNode del controlador
    return ElevatedButton(
      onPressed: effectiveOnPressed,
      focusNode: focusNode, // Utilitzem el node de focus del controlador
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: model.iconData != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(model.iconData),
                if (model.text != null) 
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(text),
                  ),
              ],
            )
          : Text(text),
    );
  }
}