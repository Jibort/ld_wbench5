// lib/ui/widgets/ld_button/ld_button_ctrl.dart
// Controlador pel widget LdButton.
// Actualitzat amb gestió de visibilitat, focus i estat actiu.
// Created: 2025/05/01 dc. JIQ
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdButton
class LdButtonCtrl extends LdWidgetCtrlAbs<LdButton> {
  // Constructor
  LdButtonCtrl(super.pWidget);
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador de botó");
    
    // El botó normalment no necessita model ja que no té estat persistent
    // Si en el futur necessitem estat, podem crear-lo aquí
    
    // Carregar la configuració del controlador
    _loadControllerConfig();
  }
  
  /// Carrega la configuració del controlador des del widget
  void _loadControllerConfig() {
    final config = widget.config;
    
    // Carregar propietats de configuració (cf)
    final buttonText = config[cfButtonText] as String? ?? "";
    final icon = config[cfIcon] as IconData?;
    
    Debug.info("$tag: Configuració carregada: text='$buttonText', hasIcon=${icon != null}");
  }
  
  /// Mètode per executar quan es prem el botó
  void press() {
    Debug.info("$tag: Botó premut");
    
    // Només executar si està actiu
    if (isEnabled) {
      // Cridar el callback si existeix
      _callOnPressed();
      
      // Opcional: Emetre un event
      // EventBus.s.emit(LdEvent(...));
    } else {
      Debug.warn("$tag: Botó premut però està desactivat");
    }
  }
  
  /// Crida el callback onPressed si existeix
  void _callOnPressed() {
    final config = widget.config;
    final onPressed = config[efOnPressed] as VoidCallback?;
    
    if (onPressed != null) {
      onPressed();
      Debug.info("$tag: Callback onPressed executat");
    }
  }
  
  @override
  void update() {
    // No hi ha estat del model que actualitzar
  }
  
  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut event ${event.eType.name}");
    
    // Gestionar els events que ens interessen
    if (event.eType == EventType.themeChanged) {
      Debug.info("$tag: Processant canvi de tema");
      if (mounted) {
        setState(() {
          // La UI es reconstruirà amb el nou tema
        });
      }
    }
  }
  
  @override
  void onModelChanged(LdModelAbs pModel, void Function() updateFunction) {
    // El botó no té model normalment, però si en tenim un:
    Debug.info("$tag: Model de botó ha canviat");
    updateFunction();
    
    if (mounted) {
      setState(() {
        Debug.info("$tag: Reconstruint després del canvi del model");
      });
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    final config = widget.config;
    
    // Obtenir propietats de configuració
    final buttonText = config[cfButtonText] as String? ?? "";
    final icon = config[cfIcon] as IconData?;
    final style = config[cfButtonStyle] as ButtonStyle?;
    
    // Determinar el tipus de botó segons la configuració
    if (icon != null && buttonText.isNotEmpty) {
      // Botó amb icona i text
      return ElevatedButton.icon(
        onPressed: isEnabled ? press : null,
        icon: Icon(icon),
        label: Text(buttonText),
        style: style,
      );
    } else if (icon != null) {
      // Botó només amb icona
      return IconButton(
        onPressed: isEnabled ? press : null,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          // Adaptar l'estil si cal
        ),
      );
    } else {
      // Botó només amb text
      return ElevatedButton(
        onPressed: isEnabled ? press : null,
        style: style,
        child: Text(buttonText),
      );
    }
  }
}