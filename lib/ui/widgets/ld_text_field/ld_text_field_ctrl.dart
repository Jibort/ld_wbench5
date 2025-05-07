// lib/ui/widgets/ld_text_field/ld_text_field_ctrl.dart
// Controlador del widget 'LdTextField'.
// Created: 2025/05/06 dt. CLA

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdTextField
class LdTextFieldCtrl extends LdWidgetCtrlAbs<LdTextField> {
  // Controller per al TextField
  late final TextEditingController _textController;
  
  // Flag para evitar actualizaciones circulares
  bool _isUpdatingFromModel = false;
  
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
    // Evitar actualitzacions circulars
    if (_isUpdatingFromModel) return;
    
    final text = _textController.text;
    
    if (text != model.text) {
      Debug.info("$tag: Text canviat des del teclat a '$text'");
      // Actualitzar el model amb el nou text
      model.text = text;
    }
  }
  
  /// Actualitza el text del controller a partir del model
  void _updateControllerText() {
    if (_textController.text != model.text) {
      _isUpdatingFromModel = true;
      
      _textController.text = model.text;
      // Posicionar el cursor al final
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
      
      _isUpdatingFromModel = false;
      Debug.info("$tag: TextController actualitzat a '${model.text}'");
    }
  }
  
  /// Nou mètode per afegir text directament
  void addText(String text) {
    Debug.info("$tag: Afegint text '$text' directament des del controlador");
    
    // Actualitzar el model directament
    final newText = model.text + text;
    
    // Actualitzar el model sense usar els mètodes que poden causar cicles
    _isUpdatingFromModel = true;
    
    // Actualitzar el model primer
    model.text = newText;
    
    // Després actualitzar el controller
    _textController.text = newText;
    
    // Posicionar el cursor al final
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
    
    _isUpdatingFromModel = false;
    
    // Opcional: Forçar reconstrucció per a assegurar que la UI es refresca
    if (mounted) {
      setState(() {
        Debug.info("$tag: UI reconstruïda després d'afegir text");
      });
    }
  }
  
  /// Nou mètode per afegir text al principi
  void prependText(String prefix) {
    Debug.info("$tag: Afegint prefix '$prefix' directament des del controlador");
    
    final newText = prefix + model.text;
    
    _isUpdatingFromModel = true;
    
    // Actualitzar el model
    model.text = newText;
    
    // Actualitzar el controller
    _textController.text = newText;
    
    // Posicionar el cursor al final
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
    
    _isUpdatingFromModel = false;
    
    if (mounted) {
      setState(() {
        Debug.info("$tag: UI reconstruïda després d'afegir prefix");
      });
    }
  }
  
  /// Nou mètode per netejar el text
  void clearText() {
    Debug.info("$tag: Netejant text des del controlador");
    
    _isUpdatingFromModel = true;
    
    // Actualitzar el model
    model.text = "";
    
    // Actualitzar el controller
    _textController.text = "";
    
    _isUpdatingFromModel = false;
    
    if (mounted) {
      setState(() {
        Debug.info("$tag: UI reconstruïda després de netejar text");
      });
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
  void onModelChanged(LdModelAbs pModel, void Function() updateFunction) {
    Debug.info("$tag: Model ha canviat");
    
    // Executar la funció d'actualització
    updateFunction();
    
    // Si no estem ja actualitzant des del controlador,
    // actualitzar el TextEditingController
    if (!_isUpdatingFromModel) {
      _updateControllerText();
    }
    
    // Reconstruir si està muntat
    if (mounted) {
      setState(() {
        Debug.info("$tag: Reconstruint després del canvi del model");
      });
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
