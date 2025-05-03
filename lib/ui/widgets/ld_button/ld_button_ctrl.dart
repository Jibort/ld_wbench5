// lib/ui/widgets/ld_button/ld_button_ctrl.dart
// Controlador pel widget LdButton.
// Actualitzat amb gestió de visibilitat, focus i estat actiu.
// Created: 2025/05/01 dc. JIQ
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador pel widget LdButton.
class LdButtonCtrl extends LdWidgetCtrlAbs<LdButton> {
  /// Retorna el model del widget.
  LdButtonModel get model => cWidget.wModel as LdButtonModel;

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
    
    // El registre com a observador del model ara es fa automàticament a la classe base
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut esdeveniment ${event.eType.name}");
    
    // Gestionar canvis d'idioma
    if (event.eType == EventType.languageChanged) {
      Debug.info("$tag: Processant esdeveniment de canvi d'idioma");
      
      // Forçar una reconstrucció del botó per actualitzar el text
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció del botó amb el nou idioma");
        });
      }
    }
    
    // Gestionar canvis de tema
    if (event.eType == EventType.themeChanged) {
      Debug.info("$tag: Processant esdeveniment de canvi de tema");
      
      // Forçar una reconstrucció del botó per actualitzar l'estil
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció del botó amb el nou tema");
        });
      }
    }
    
    // Gestionar reconstrucció global de la UI
    if (event.eType == EventType.rebuildUI) {
      Debug.info("$tag: Processant esdeveniment de reconstrucció de la UI");
      
      if (mounted) {
        setState(() {
          Debug.info("$tag: Reconstruint el botó");
        });
      }
    }
  }
  
  /// Alterna la visibilitat del botó
  @override
  void toggleVisibility() {
    Debug.info("$tag: Cridant a toggleVisibility(). Estat actual: $isVisible");
    
    setState(() {
      isVisible = !isVisible;
      Debug.info("$tag: Visibilitat alternada a $isVisible");
    });
  }
  
  /// Alterna l'estat d'activació del botó
  @override
  void toggleEnabled() {
    Debug.info("$tag: Cridant a toggleEnabled(). Estat actual: $isEnabled");
    
    setState(() {
      isEnabled = !isEnabled;
      Debug.info("$tag: Estat d'activació alternat a $isEnabled");
    });
  }
  
  @override
  Widget buildContent(BuildContext context) {
    String text = (model.text == null && model.iconData == null) ? errInText : model.text ?? errInText;
    
    // Determinar si el botó està actiu
    final VoidCallback? effectiveOnPressed = isEnabled ? onPressed : null;
    
    Debug.info("$tag: Construint el botó. Text: '$text', Visible: $isVisible, Enabled: $isEnabled");
    
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
