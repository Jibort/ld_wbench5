// lib/ui/widgets/ld_text_field/ld_text_field_ctrl.dart
// Controlador del widget 'LdTextField'.
// Created: 2025/05/06 dt. CLA

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdTextField
class LdTextFieldCtrl extends LdWidgetCtrlAbs<LdTextField> {
  // Controller per al TextField
  late final TextEditingController _textController;
  
  // Focus node per al TextField (utilitzem el de la classe base)
  
  // Constructor
  LdTextFieldCtrl(
    super.pWidget, {
    String? initialText,
    super.canFocus,
    super.isEnabled,
    super.isVisible,
  }) {
    // Inicialitzem el controller amb el text inicial
    _textController = TextEditingController(text: initialText ?? "");
  }
  
  /// Retorna el model
  LdTextFieldModel get model => widget.wModel as LdTextFieldModel;
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador");
    
    // Configurar listener per mantenir sincronitzat el model amb el textController
    _textController.addListener(_onTextChange);
    
    // Actualitzar el text del controller amb el del model
    _updateControllerText();
  }
  
  /// S'executa quan canvia el text al textController
  void _onTextChange() {
    final text = _textController.text;
    
    if (text != model.text) {
      // Actualitzar el model amb el nou text
      model.text = text;
    }
  }
  
  /// Actualitza el text del controller a partir del model
  void _updateControllerText() {
    if (_textController.text != model.text) {
      _textController.text = model.text;
      // Posicionar el cursor al final
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }
  }
  
  @override
  void update() {
    // Actualitzar el text del controller amb el del model
    _updateControllerText();
  }
  
  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut event ${event.eType.name}");
    
    // Gestionem els events que ens interessen
    if (event.eType == EventType.languageChanged) {
      Debug.info("$tag: Processant canvi d'idioma");
      if (mounted) {
        setState(() {
          // Els texts traduïts s'actualitzaran automàticament
        });
      }
    }
  }
  
  @override
  void dispose() {
    _textController.removeListener(_onTextChange);
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // El TextField amb l'etiqueta
        TextField(
          controller: _textController,
          focusNode: focusNode,
          enabled: isEnabled,
          decoration: InputDecoration(
            labelText: model.label,
            helperText: model.helpText,
            errorText: model.hasError ? model.errorMessage : null,
            border: OutlineInputBorder(),
            isDense: true,
          ),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
