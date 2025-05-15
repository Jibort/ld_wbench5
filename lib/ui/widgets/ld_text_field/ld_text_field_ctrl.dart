// lib/ui/widgets/ld_text_field/ld_text_field_ctrl.dart
// Controlador del widget 'LdTextField'.
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/13 dt. CLA - Correcció del mètode initialize

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdTextField
class LdTextFieldCtrl extends LdWidgetCtrlAbs<LdTextField> {
  // MEMBRES ==============================================
  /// Controller per al TextField
  late final TextEditingController _textController;
  
  // Flag para evitar actualizaciones circulares
  bool _isUpdatingFromModel = false;
  
  // CONSTRUCTORS/INICIALITZADORS/DESTRUCTORS =============
  // Constructor
  LdTextFieldCtrl(super.pWidget);
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador");
    
    // Crear el model amb la configuració del widget
    _createModel();
    
    // Inicialitzar el controller del text amb el valor del model
    final textModel = model as LdTextFieldModel?;
    final initialText = textModel?.text ?? "";
    
    Debug.info("$tag: Text inicial del model: '$initialText'");
    
    _textController = TextEditingController(text: initialText);
    
    // Configurar listener per mantenir sincronitzat el model amb el textController
    _textController.addListener(_onTextChange);
    
    Debug.info("$tag: TextEditingController creat amb text: '${_textController.text}'");
  }
  
  /// Crea el model del TextField
  void _createModel() {
    Debug.info("$tag: Creant model del TextField");
    
    try {
      // Crear el model amb la configuració del widget
      model = LdTextFieldModel.fromMap(widget.config);
      
      Debug.info("$tag: Model creat amb èxit. Text: '${(model as LdTextFieldModel).text}'");
    } catch (e) {
      Debug.error("$tag: Error creant model: $e");
      // Crear un model buit per defecte en cas d'error
      try {
        model = LdTextFieldModel.fromMap({});
        Debug.info("$tag: Model de recanvi creat");
      } catch (e2) {
        Debug.error("$tag: Error creant model de recanvi: $e2");
      }
    }
  }
  
  /// S'executa quan canvia el text al textController
  void _onTextChange() {
    // Evitar actualitzacions circulars
    if (_isUpdatingFromModel) return;
    
    final text = _textController.text;
    final textModel = model as LdTextFieldModel?;
    
    if (textModel != null && text != textModel.text) {
      Debug.info("$tag: Text canviat des del teclat a '$text'");
      
      // Actualitzar el model amb el nou text
      textModel.updateField(mfText, text);
      
      // Cridar el callback si existeix
      _callOnTextChanged(text);
    }
  }
  
  /// Crida el callback onTextChanged si existeix
  void _callOnTextChanged(String text) {
    final config = widget.config;
    final onTextChanged = config[efOnTextChanged] as Function(String)?;
    
    if (onTextChanged != null) {
      onTextChanged(text);
    }
  }
  
  /// Actualitza el text del controller a partir del model
  void _updateControllerText() {
    final textModel = model as LdTextFieldModel?;
    if (textModel == null) return;
    
    final modelText = textModel.text;
    if (_textController.text != modelText) {
      _isUpdatingFromModel = true;
      _textController.text = modelText;
      
      // Posicionar el cursor al final
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
      _isUpdatingFromModel = false;
      
      Debug.info("$tag: TextController actualitzat a '$modelText'");
    }
  }
  
  /// Afegeix text directament
  void addText(String text) {
    Debug.info("$tag: Afegint text '$text' directament");
    final textModel = model as LdTextFieldModel?;
    if (textModel != null) {
      final newText = textModel.text + text;
      textModel.updateField(mfText, newText);
    }
  }
  
  /// Afegeix text al principi
  void prependText(String prefix) {
    Debug.info("$tag: Afegint prefix '$prefix' directament");
    final textModel = model as LdTextFieldModel?;
    if (textModel != null) {
      final newText = prefix + textModel.text;
      textModel.updateField(mfText, newText);
    }
  }
  
  /// Neteja el text
  void clearText() {
    Debug.info("$tag: Netejant text");
    final textModel = model as LdTextFieldModel?;
    if (textModel != null) {
      textModel.updateField(mfText, "");
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
    
    // Gestionar els events que ens interessen
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
    
    // Actualitzar el TextEditingController si és necessari
    _updateControllerText();
    
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
    final config = widget.config;
    final theme = Theme.of(context);
    
    // Obtenir propietats de configuració
    final label = (config[cfLabel] as String?)?.tx();
    final helpText = (config[cfHelpText] as String?)?.tx();
    final errorMessage = (config[cfErrorMessage] as String?)?.tx();
    final hasError = config[cfHasError] as bool? ?? false;
    
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
            labelText: label,
            helperText: helpText,
            errorText: hasError ? errorMessage : null,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}