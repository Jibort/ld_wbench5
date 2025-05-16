// lib/ui/widgets/ld_label/ld_label_ctrl.dart
// Controlador del widget LdLabel
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/15 dc. GPT(JIQ) - Usa RichText per mostrar etiquetes amb interpolació

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_model.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';

class LdLabelCtrl extends LdWidgetCtrlAbs<LdLabel> {
  // CONSTRUCTORS/INICIALITZADORS/DESTRUCTORS =============
  LdLabelCtrl(super.pWidget);

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador d'etiqueta");
    _createModel();
    Debug.info("$tag: Model creat amb text: '${(model as LdLabelModel?)?.label ?? ''}'");
  }

  void _createModel() {
    Debug.info("$tag: Creant model del Label");
    try {
      model = LdLabelModel.fromMap(widget.config);
      Debug.info("$tag: Model creat amb èxit. Text: '${(model as LdLabelModel).label}'");
    } catch (e) {
      Debug.error("$tag: Error creant model: $e");
      try {
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
      Debug.info("$tag: Processant canvi ${event.eType.name}");
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

    final translated = labelModel.label.tx(
      labelModel.positionalArgs,
      labelModel.namedArgs,
    );

    Debug.info("$tag: Renderitzant RichText amb: '$translated'");

    return RichText(
      text: TextSpan(
        text: translated,
        style: labelModel.labelStyle ?? Theme.of(context).textTheme.bodyLarge,
      ),
      textAlign: labelModel.textAlign ?? TextAlign.start,
      maxLines: labelModel.maxLines,
      overflow: labelModel.overflow ?? TextOverflow.clip,
      softWrap: labelModel.softWrap ?? true,
    );
  }

  // MÈTODES ESPECÍFICS DEL LABEL =========================
  void updateLabel(String pNewLabel) {
    final labelModel = model as LdLabelModel?;
    if (labelModel != null) {
      labelModel.label = pNewLabel;
      Debug.info("$tag: Text actualitzat a '$pNewLabel'");
    }
  }

  void updateTranslationParams({
    List<String>? positionalArgs,
    LdMap<String>? namedArgs,
  }) {
    final labelModel = model as LdLabelModel?;
    if (labelModel != null) {
      // IMPORTANT: NO perdis la clau original del label
      labelModel.notifyListeners(() {
        if (positionalArgs != null) labelModel.positionalArgs = positionalArgs;
        if (namedArgs != null) labelModel.namedArgs = namedArgs;
        // La clau del label no canvia, només els arguments
      });
      Debug.info("$tag: Arguments actualitzats. Clau: '${labelModel.label}'");
    }
  }

  TextStyle? getCurrentLabelStyle() {
    final labelModel = model as LdLabelModel?;
    return labelModel?.labelStyle;
  }

  void updateLabelStyle(TextStyle? newStyle) {
    final labelModel = model as LdLabelModel?;
    if (labelModel != null) {
      labelModel.labelStyle = newStyle;
      Debug.info("$tag: Estil de text actualitzat");
    }
  }
}
