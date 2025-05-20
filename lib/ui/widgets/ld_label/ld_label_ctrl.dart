// lib/ui/widgets/ld_label/ld_label_ctrl.dart
// Controlador per al widget LdLabel
// Created: 2025/05/20 dl. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

class LdLabelCtrl extends LdWidgetCtrlAbs<LdLabel> {
  // Constructor
  LdLabelCtrl(super.pWidget);

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador d'etiqueta");
    _createModel();
  }

  void _createModel() {
  try {
    // Ara passem els configs al constructor
    model = LdLabelModel.fromMap(widget.config);
    Debug.info("$tag: Model creat amb èxit. Text: '${(model as LdLabelModel).label}'");
  } catch (e) {
    Debug.error("$tag: Error creant model: $e");
    try {
      // Per al model de recanvi, passem un mapa buit
      model = LdLabelModel.fromMap({});
      Debug.info("$tag: Model de recanvi creat");
    } catch (e2) {
      Debug.error("$tag: Error creant model de recanvi: $e2");
    }
  }
}
  @override
  void update() {
    Debug.info("$tag: Actualització del controlador d'etiqueta");
  }

  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut event ${event.eType.name}");
    if (event.eType == EventType.languageChanged || event.eType == EventType.themeChanged) {
      if (mounted) {
        setState(() {
          Debug.info("$tag: Reconstruint després de canvi");
        });
      }
    }
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    Debug.info("$tag: Model ha canviat");
    pfnUpdate();
    if (mounted) {
      setState(() {
        Debug.info("$tag: Reconstruint després del canvi del model");
      });
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final labelModel = model as LdLabelModel?;
    if (labelModel == null) {
      Debug.warn("$tag: Model no disponible, mostrant text buit");
      return const SizedBox.shrink();
    }

    return Text(
      labelModel.translatedText,
      style: labelModel.style,
      textAlign: labelModel.textAlign,
      overflow: labelModel.overflow,
      maxLines: labelModel.maxLines,
      softWrap: labelModel.softWrap,
    );
  }

  // Mètodes específics del Label
  void updateLabel(String pNewLabel) {
    final labelModel = model as LdLabelModel?;
    if (labelModel != null) {
      labelModel.setField(pKey: cfLabel, pValue: pNewLabel);
      Debug.info("$tag: Text actualitzat a '$pNewLabel'");
    }
  }

  void updateTranslationParams({
    List<String>? positionalArgs,
    MapStrings? namedArgs,
  }) {
    final labelModel = model as LdLabelModel?;
    if (labelModel != null) {
      labelModel.updateTranslationArgs(
        positionalArgs: positionalArgs,
        namedArgs: namedArgs,
      );
      Debug.info("$tag: Arguments de traducció actualitzats");
    }
  }
}