// lib/ui/widgets/ld_check_box/ld_check_box_ctrl.dart
// Controlador per al widget LdCheckBox.
// Created: 2025/05/17 ds. GPT(JIQ)
// Updated: 2025/05/18 ds. GEM - Implementació inicial del controlador.
// Updated: 2025/05/19 dg. CLA - Correcció d'arquitectura, eliminació de dependència a TestPage2.

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box.dart';

/// Controlador per al widget LdCheckBox.
/// Gestiona la interacció amb l'usuari, l'estat visual i la lògica de negoci.
class LdCheckBoxCtrl extends LdWidgetCtrlAbs<LdCheckBox> {

  // MEMBRES ==============================================
  /// Accés ràpid al model amb tipus segur.
  LdCheckBoxModel? get checkboxModel => model as LdCheckBoxModel?;
  
  /// Guarda l'estat inicial de selecció per comparar amb canvis posteriors
  bool? _initialCheckedState;

  // CONSTRUCTORS/INICIALITZADORS/DESTRUCTORS =============
  /// Constructor.
  LdCheckBoxCtrl(super.pWidget);

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador.");
    _createModel();
    
    // Guardar l'estat inicial per a futures comparacions
    _initialCheckedState = checkboxModel?.isChecked;
  }

  /// Crea el model del CheckBox a partir de la configuració del widget.
  void _createModel() {
    Debug.info("$tag: Creant model del CheckBox.");
    try {
      // Obtenir l'estat inicial des de la configuració (mfIsChecked o cfInitialChecked)
      final initialChecked = widget.config[mfIsChecked] as bool? ?? 
                            widget.config[cfInitialChecked] as bool? ??
                            false;

      // Construir el mapa mínim necessari per al model
      MapDyns modelConfig = MapDyns();
      modelConfig[cfTag] = tag; // Sempre incloure el tag
      modelConfig[mfIsChecked] = initialChecked; // Estat inicial (mf)
      modelConfig[cfLabel] = widget.config[cfLabel] ?? ''; // Label source (cf)

      // Afegir altres cf* rellevants per a l'estat/config del model si existeixen
      if (widget.config.containsKey(cfLabelPosArgs)) modelConfig[cfLabelPosArgs] = widget.config[cfLabelPosArgs];
      if (widget.config.containsKey(cfLabelNamedArgs)) modelConfig[cfLabelNamedArgs] = widget.config[cfLabelNamedArgs];
      if (widget.config.containsKey(cfLeadingIcon)) modelConfig[cfLeadingIcon] = widget.config[cfLeadingIcon];
      if (widget.config.containsKey(cfCheckPosition)) modelConfig[cfCheckPosition] = widget.config[cfCheckPosition];
      if (widget.config.containsKey(cfInfoTextKey)) modelConfig[cfInfoTextKey] = widget.config[cfInfoTextKey];
      if (widget.config.containsKey(cfShowInfoIcon)) modelConfig[cfShowInfoIcon] = widget.config[cfShowInfoIcon];

      // Crear el model a partir del mapa de configuració.
      model = LdCheckBoxModel.fromMap(modelConfig);
      Debug.info("$tag: Model creat amb èxit des de config. isChecked: ${checkboxModel?.isChecked}");

    } catch (e) {
      // Si hi ha un error, crear un model de recanvi amb valors per defecte.
      Debug.error("$tag: Error creant model des de config: $e. Creant model de recanvi.");
      try {
        // Assegurar-nos que les propietats essencials tenen valors segurs per defecte.
        MapDyns fallbackConfig = MapDyns();
        fallbackConfig[cfTag] = tag; // Sempre incloure el tag
        fallbackConfig[mfIsChecked] = false; // Estat per defecte false
        fallbackConfig[cfLabel] = 'Error Label'; // Text per defecte indicant error

        model = LdCheckBoxModel.fromMap(fallbackConfig);
        Debug.info("$tag: Model de recanvi creat amb èxit.");
      } catch (e2) {
        Debug.fatal("$tag: Error fatal creant model de recanvi: $e2");
      }
    }
  }

  @override
  void update() {
    Debug.info("$tag: Actualització del controlador.");
  }

  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut event ${event.eType.name}.");
    if (event.eType == EventType.languageChanged || event.eType == EventType.themeChanged) {
      if (mounted) {
        setState(() {
          // L'actualització del model (si la necessita per canvi d'idioma/tema)
          // i la reconstrucció automàtica gestionaran la UI.
        });
      }
    }
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    Debug.info("$tag: Model ha canviat. Executant actualització de UI.");
    pfnUpdate();
    
    // Comprovar si l'estat ha canviat des de l'inici i persistir 
    // el canvi si és necessari
    if (checkboxModel != null && _initialCheckedState != checkboxModel!.isChecked) {
      // Actualitzar l'estat inicial per a futures comparacions
      _initialCheckedState = checkboxModel!.isChecked;
    }
  }

  // FUNCIONALITAT D'INTERACCIÓ =========================
  /// Gestió del toggle de l'estat del checkbox quan l'usuari interacciona (toca).
  void _handleTap() {
    Debug.info("$tag: Checkbox premut.");
    
    // Alternar l'estat del model. El model notificarà als seus observadors
    checkboxModel?.toggle();

    // Cridar el callback onToggled si existeix, passant el nou estat.
    final onToggledCallback = widget.config[efOnToggled] as Function(bool)?;
    if (onToggledCallback != null && checkboxModel != null) {
      onToggledCallback(checkboxModel!.isChecked);
      Debug.info("$tag: Executant callback onToggled amb estat ${checkboxModel!.isChecked}.");
    }

    // Forçar actualització si està muntat
    if (mounted) {
      setState(() {
        Debug.info("$tag: Actualitzant UI després del canvi d'estat.");
      });
    }
  }

   /// Gestió de la pressió a la icona d'informació.
   void _handleInfoTap() {
     Debug.info("$tag: Icona d'informació premut.");
     // Cridar el callback onInfoTapped si existeix.
     final onInfoTappedCallback = widget.config[efOnInfoTapped] as VoidCallback?;
     if (onInfoTappedCallback != null) {
       onInfoTappedCallback();
       Debug.info("$tag: Executant callback onInfoTapped.");
     } else {
       // Comportament per defecte si no hi ha callback
       Debug.info("$tag: No hi ha callback onInfoTapped definit. Mostrant informació via Snackbar.");
       _showInfoSnackBar();
     }
   }

   /// Mètode auxiliar per mostrar la informació addicional en un Snackbar.
   void _showInfoSnackBar() {
     final infoText = checkboxModel?.translatedInfoText;
     if (infoText != null && infoText.isNotEmpty) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(infoText),
             duration: const Duration(seconds: 3),
           ),
         );
       } else {
          Debug.warn("$tag: No s'ha pogut mostrar Snackbar, widget no muntat.");
       }
     } else {
        Debug.warn("$tag: No hi ha text d'informació per mostrar al Snackbar.");
     }
   }

  // CONSTRUCCIÓ DEL WIDGET VISUAL =======================
  @override
  Widget buildContent(BuildContext context) {
    // Si no hi ha model, mostrar un contenidor buit
    final model = checkboxModel;
    if (model == null) {
      Debug.warn("$tag: Model no disponible, mostrant SizedBox buit");
      return const SizedBox.shrink();
    }

    // Obtenir el tema actual per aplicar estils.
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Crear el widget de text del label.
    final labelWidget = Flexible(
      child: Text(
        model.translatedLabel,
        style: theme.textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
    );

    // Crear la icona opcional d'informació.
    final infoIconWidget = model.showInfoIcon && model.translatedInfoText != null
        ? Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: GestureDetector(
              onTap: _handleInfoTap,
              child: Icon(
                Icons.info_outline,
                size: 18.0,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          )
        : const SizedBox.shrink();

    // Crear la icona opcional al principi del text.
    final leadingIconWidget = model.leadingIcon != null
        ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              model.leadingIcon,
              size: 20.0,
              color: theme.textTheme.bodyMedium?.color,
            ),
          )
        : const SizedBox.shrink();

    // Crear el widget Checkbox de Flutter.
    final checkboxRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Col·locar el Checkbox a l'esquerra o a la dreta segons model.checkPosition
        if (model.checkPosition == CheckPosition.left) ...[
          Checkbox(
            value: model.isChecked, // Usem directament l'estat del model
            onChanged: (bool? newValue) {
              _handleTap();
            },
            focusNode: focusNode,
            // Aplicar estil de focus a la vora del checkbox
            side: MaterialStateBorderSide.resolveWith(
              (states) {
                if (states.contains(MaterialState.focused)) {
                  return BorderSide(color: colorScheme.primary, width: 2.0);
                }
                return null;
              }
            ),
            // Usar el color de fons del TextField (eliminat el gris)
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return colorScheme.primary;
              }
              return Colors.transparent; // Fons transparent per igualtar amb TextField
            }),
          ),
          const SizedBox(width: 8.0),
        ],

        leadingIconWidget,

        labelWidget,

        infoIconWidget,

        if (model.checkPosition == CheckPosition.right) ...[
          const SizedBox(width: 8.0),
          Checkbox(
            value: model.isChecked, // Usem directament l'estat del model
            onChanged: (bool? newValue) {
              _handleTap();
            },
            focusNode: focusNode,
            // Aplicar estil de focus a la vora del checkbox
            side: MaterialStateBorderSide.resolveWith(
              (states) {
                if (states.contains(MaterialState.focused)) {
                  return BorderSide(color: colorScheme.primary, width: 2.0);
                }
                return null;
              }
            ),
            // Usar el color de fons del TextField (eliminat el gris)
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return colorScheme.primary;
              }
              return Colors.transparent; // Fons transparent per igualtar amb TextField
            }),
          ),
        ],
      ],
    );

    // Envoltem la Row amb un GestureDetector per fer tota l'àrea interactiva.
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: checkboxRow,
      ),
    );
  }
}