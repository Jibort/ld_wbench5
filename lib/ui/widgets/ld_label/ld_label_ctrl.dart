// lib/ui/widgets/ld_label/ld_label_ctrl.dart
// Controlador del widget LdLabel.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdLabel.
class LdLabelCtrl extends LdWidgetCtrlAbs<LdLabel> {
  /// Constructor
  LdLabelCtrl(super.pWidget);

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador del label");
    
    // Crear el model amb la configuració del widget
    final config = widget.config;
    final text = config[mfText] as String? ?? "";
    final args = config[mfArgs] as List<dynamic>?;
    
    model = LdLabelModel(widget, text: text, args: args);
    
    // Registrar aquest widget per rebre events de canvi d'idioma
    EventBus.s.registerForEvent(tag, EventType.languageChanged);
    
    Debug.info("$tag: Controlador inicialitzat i registrat per rebre events de canvi d'idioma");
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void dispose() {
    // Desregistrar callbacks de models externs
    widget.detachFromAllModels();
    super.dispose();
  }
  
  @override
  void onEvent(LdEvent event) {
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
  
  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
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
    final labelModel = model as LdLabelModel?;
    String text = labelModel?.displayText ?? "";
    
    Debug.info("$tag: Construint el text '$text'");
    
    // Obtenir propietats de configuració
    final config = widget.config;
    final style = config[cfTextStyle] as TextStyle?;
    final textAlign = config[cfTextAlign] as TextAlign?;
    final textDirection = config[cfTextDirection] as TextDirection?;
    final locale = config[cfLocale] as Locale?;
    final softWrap = config[cfSoftWrap] as bool?;
    final overflow = config[cfOverflow] as TextOverflow?;
    // final textScaleFactor = config[cfTextScaleFactor] as double?;
    final textScaler = config[cfTextScaler] as TextScaler?;
    final maxLines = config[cfMaxLines] as int?;
    final semanticsLabel = config[cfSemanticLabel] as String?;
    final textWidthBasis = config[cfTextWidthBasis] as TextWidthBasis?;
    final textHeightBehavior = config[cfTextHeightBehavior] as TextHeightBehavior?;
    final selectionColor = config[cfSelectionColor] as Color?;
    final strutStyle = config[cfStructStyle] as StrutStyle?;
    
    // Crear el widget Text SENSE la key del widget pare per evitar duplicats
    return Text(
      text,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      // textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}