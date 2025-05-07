// lib/ui/widgets/ld_text/ld_label_ctrl.dart
// Controlador del widget LdText.
// Created: 2025/05/06 dt. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdText.
class LdLabelCtrl extends LdWidgetCtrlAbs<LdLabel> {
  /// Estil del text
  final TextStyle? style;
  
  /// Alineació del text
  final TextAlign? textAlign;
  
  /// Nombre màxim de línies
  final int? maxLines;
  
  /// Gestió del desbordament de text
  final TextOverflow? overflow;
  
  /// Constructor
  LdLabelCtrl(
    super.pWidget, {
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  void dispose() {
    widget.detachFromAllModels();
    super.dispose();
}

  /// Retorna el model del widget.
  LdLabelModel get model => cWidget.wModel as LdLabelModel;

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador del text");
    
    // Registrar aquest widget per rebre events de canvi d'idioma
    EventBus.s.registerForEvent(tag, EventType.languageChanged);
    
    Debug.info("$tag: Controlador inicialitzat i registrat per rebre events de canvi d'idioma");
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override onEvent(LdEvent event) {
    Debug.info("$tag: Rebut esdeveniment ${event.eType.name}");
    
    // Gestionar canvis d'idioma
    if (event.eType == EventType.languageChanged) {
      Debug.info("$tag: Processant esdeveniment de canvi d'idioma");
      
      // Forçar una reconstrucció del text per actualitzar-lo
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció del text amb el nou idioma");
        });
      }
    }
    
    // Gestionar reconstrucció global de la UI
    if (event.eType == EventType.rebuildUI) {
      Debug.info("$tag: Processant esdeveniment de reconstrucció de la UI");
      
      if (mounted) {
        setState(() {
          Debug.info("$tag: Reconstruint el text");
        });
      }
    }
  }
  
  @override onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    Debug.info("$tag: Model ha canviat");
    
    // Executar la funció d'actualització
    pfUpdate();
    
    // Reconstruir si està muntat
    if (mounted) {
      setState(() {
        Debug.info("$tag: Reconstruint després del canvi del model");
      });
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    String text = model.displayText;
    
    Debug.info("$tag: Construint el text '$text'");
    
    // Crear el widget Text amb els paràmetres opcionals
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}