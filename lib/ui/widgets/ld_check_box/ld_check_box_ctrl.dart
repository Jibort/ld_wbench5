// lib/ui/widgets/ld_check_box/ld_check_box_ctrl.dart
// Controlador per al widget LdCheckBox.
// Created: 2025/05/17 ds. GPT(JIQ)
// Updated: 2025/05/18 ds. GEM - Implementació inicial del controlador.
// Updated: 2025/05/18 ds. GEM - Correcció de constants i implementació UI segons especificacions.
// Updated: 2025/05/18 ds. GEM - Importació de CheckPosition des de ld_check_box.dart.

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box.dart'; // Importar el widget (inclou CheckPosition i exporta model/ctrl)


/// Controlador per al widget LdCheckBox.
/// Gestiona la interacció amb l'usuari, l'estat visual i la lògica de negoci.
class LdCheckBoxCtrl extends LdWidgetCtrlAbs<LdCheckBox> {

  // MEMBRES ==============================================
  /// Accés ràpid al model amb tipus segur.
  LdCheckBoxModel? get checkboxModel => model as LdCheckBoxModel?;

  // CONSTRUCTORS/INICIALITZADORS/DESTRUCTORS =============
  /// Constructor.
  LdCheckBoxCtrl(super.pWidget);

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador.");
    _createModel(); // Crear o restaurar el model
    // No cal subscriure a events específics aquí si la base LdWidgetCtrlAbs
    // ja gestiona events globals com languageChanged.
    // Podríem afegir listeners a models externs si aquest checkbox depengués d'ells.
  }

  /// Crea el model del CheckBox a partir de la configuració del widget.
  /// Intenta carregar l'estat inicial des de la configuració del widget (cfInitialChecked).
  void _createModel() {
    Debug.info("$tag: Creant model del CheckBox.");
    try {
      // Obtenir l'estat inicial des de la configuració (cfInitialChecked)
      final initialChecked = widget.config[cfInitialChecked] as bool? ?? false;

      // Construir el mapa mínim necessari per al model
      MapDyns modelConfig = MapDyns();
      modelConfig[cfTag] = tag; // Sempre incloure el tag
      modelConfig[mfIsChecked] = initialChecked; // Estat inicial (mf)
      modelConfig[cfLabel] = widget.config[cfLabel] ?? ''; // Label source (cf)

      // Afegir altres cf* rellevants per a l'estat/config del model si existeixen a la config del widget
       if (widget.config.containsKey(cfLabelPosArgs)) modelConfig[cfLabelPosArgs] = widget.config[cfLabelPosArgs];
       if (widget.config.containsKey(cfLabelNamedArgs)) modelConfig[cfLabelNamedArgs] = widget.config[cfLabelNamedArgs];
       if (widget.config.containsKey(cfLeadingIcon)) modelConfig[cfLeadingIcon] = widget.config[cfLeadingIcon];
       if (widget.config.containsKey(cfCheckPosition)) modelConfig[cfCheckPosition] = widget.config[cfCheckPosition];
       if (widget.config.containsKey(cfInfoTextKey)) modelConfig[cfInfoTextKey] = widget.config[cfInfoTextKey];
       if (widget.config.containsKey(cfShowInfoIcon)) modelConfig[cfShowInfoIcon] = widget.config[cfShowInfoIcon];
       // Note: Els callbacks (ef*) no s'afegeixen al mapa del model, es gestionen al controlador.


      // Crear el model a partir del mapa de configuració.
      model = LdCheckBoxModel.fromMap(modelConfig);
       Debug.info("$tag: Model creat amb èxit des de config. isChecked: ${checkboxModel?.isChecked}");

    } catch (e) {
      // Si hi ha un error (p.ex., configuració invàlida), crear un model de recanvi amb valors per defecte.
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
         Debug.fatal("$tag: Error fatal creant model de recanvi: $e2"); // Si fins i tot el fallback falla, és fatal.
      }
    }
  }


  @override
  void update() {
    // Aquest mètode es crida quan canvien les dependències del widget (p.ex., Theme, MediaQuery).
    // Si el checkbox necessita actualitzar alguna cosa basada en el context o tema,
    // ho podríem fer aquí. Per ara, la reconstrucció automàtica ja gestiona els canvis de tema.
     Debug.info("$tag: Actualització del controlador.");
  }

  @override
  void onEvent(LdEvent event) {
    // Aquest mètode es crida quan arriba un event a l'EventBus i està dirigit a aquest controlador
    // o és un event global (languageChanged, themeChanged, rebuildUI).
    Debug.info("$tag: Rebut event ${event.eType.name}.");
    if (event.eType == EventType.languageChanged || event.eType == EventType.themeChanged) {
      // Quan l'idioma o el tema canvien, cal reconstruir el widget per aplicar les traduccions
      // actualitzades i els estils del tema.
       Debug.info("$tag: Processant canvi ${event.eType.name}. Forçant reconstrucció.");
      if (mounted) {
        setState(() {
           // L'actualització del model (si la necessita per canvi d'idioma/tema)
           // i la reconstrucció automàtica gestionaran la UI.
        });
      }
    }
     // Gestionar altres events personalitzats si calgués.
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    // Aquest mètode es crida quan el model associat a aquest controlador (LdCheckBoxModel) canvia.
    Debug.info("$tag: Model ha canviat. Executant actualització de UI.");
    pfnUpdate(); // Executa la funció d'actualització proporcionada (normalment setState a LdWidgetCtrlAbs)

    // No cal cridar setState explícitament aquí després de pfnUpdate() si la base ja ho fa.
    // if (mounted) { setState(() {}); }
  }


  // FUNCIONALITAT D'INTERACCIÓ =========================
  /// Gesti  del toggle de l'estat del checkbox quan l'usuari interacciona (toca).
  void _handleTap() {
    Debug.info("$tag: Checkbox premut.");
    // Alternar l'estat del model. El model notificar  als seus observadors (aquest controlador).
    checkboxModel?.toggle();

    // Cridar el callback onToggled si existeix, passant el nou estat.
    final onToggledCallback = widget.config[efOnToggled] as Function(bool)?;
    if (onToggledCallback != null && checkboxModel != null) {
      onToggledCallback(checkboxModel!.isChecked);
       Debug.info("$tag: Executant callback onToggled amb estat ${checkboxModel!.isChecked}.");
    }
  }

   /// Gesti  de la pressi  a la icona d'informaci .
   void _handleInfoTap() {
     Debug.info("$tag: Icona d'informaci  premut.");
     // Cridar el callback onInfoTapped si existeix.
     final onInfoTappedCallback = widget.config[efOnInfoTapped] as VoidCallback?;
     if (onInfoTappedCallback != null) {
       onInfoTappedCallback();
        Debug.info("$tag: Executant callback onInfoTapped.");
     } else {
       // Comportament per defecte si no hi ha callback: mostrar un snackbar o un di leg simple?
       // Per ara, nom s un log i podr em afegir un snackbar amb el translatedInfoText.
        Debug.info("$tag: No hi ha callback onInfoTapped definit. Mostrant informaci  via Snackbar.");
        _showInfoSnackBar(); // M tode auxiliar per mostrar info
     }
   }

   /// M tode auxiliar per mostrar la informaci  addicional en un Snackbar.
   void _showInfoSnackBar() {
     final infoText = checkboxModel?.translatedInfoText;
     if (infoText != null && infoText.isNotEmpty) {
       // Utilitzem la utilitat de snackbar del mixin LdTaggableMixin heretat per la p gina/widget pare
       // Accedim al context de la p gina via context, ja que som State.
       if (mounted) { // Assegurar que el context  s v lid
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
        Debug.warn("$tag: No hi ha text d'informaci  per mostrar al Snackbar.");
     }
   }


  // CONSTRUCCI  DEL WIDGET VISUAL =======================
  @override
  Widget buildContent(BuildContext context) {
    // Aquest m tode construeix la UI visible del widget.
    // Accedim al model per obtenir l'estat i la configuraci  visual.
    final model = checkboxModel;
    if (model == null) {
      Debug.warn("$tag: Model is null, cannot build content. Showing empty box.");
      return const SizedBox.shrink(); // Mostrar caixa buida si el model no est  disponible.
    }

     // Obtenir el tema actual per aplicar estils.
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

     // Determinar el color de la vora del checkbox quan t  focus.
     // Utilitzem el color 'primary' del ColorScheme com a indicador de focus.
     // El gruix pot ser fix o basat en Theme.of(context).focusNode.highlightColor o similar si exist s.
     // NOTA: La gesti del focus visual a la vora del CALAIX del Checkbox la fa directament
     // el widget Checkbox de Flutter si li passem el `focusNode`. No cal fer-ho manualment
     // amb un `FocusableActionDetector` envoltant tot el widget, nom s cal passar el focusNode
     // al Checkbox i configurar el seu `side`.

     // Crear el widget de text del label.
     final labelWidget = Flexible( // Utilitzem Flexible per si el text  s llarg i volem que s'emboliqui
       child: Text(
         model.translatedLabel, // Obt  el text tradu t des del model
         style: theme.textTheme.bodyMedium, // Utilitzem un estil de text del tema
         overflow: TextOverflow.ellipsis, // Evitar overflow del text
       ),
     );

     // Crear la icona opcional d'informaci .
     final infoIconWidget = model.showInfoIcon && model.translatedInfoText != null // Nom s mostrar si cal i hi ha text
         ? Padding(
             padding: const EdgeInsets.only(left: 4.0), // Espai entre text i icona
             child: GestureDetector( // Utilitzem GestureDetector per detectar taps a la icona
               onTap: _handleInfoTap, // Gesti  del tap
               child: Icon(
                 Icons.info_outline, // Icona d'informaci
                 size: 18.0,
                 color: theme.textTheme.bodySmall?.color, // Color subtil per a la icona d'informaci
               ),
             ),
           )
         : const SizedBox.shrink(); // Widget buit si no es mostra la icona

     // Crear la icona opcional al principi del text.
     final leadingIconWidget = model.leadingIcon != null
         ? Padding(
             padding: const EdgeInsets.only(right: 8.0), // Espai entre icona i text/checkbox
             child: Icon(
               model.leadingIcon, // La icona especificada
               size: 20.0,
               color: theme.textTheme.bodyMedium?.color, // Color de l'icona similar al text
             ),
           )
         : const SizedBox.shrink(); // Widget buit si no hi ha icona inicial


     // Crear el widget Checkbox de Flutter.
     // Envoltem el Checkbox i el seu label amb un GestureDetector per fer tota l' area clicable.
     // Associem el focusNode del controlador base al Checkbox directament.
     final checkboxRow = Row( // Utilitzem un Row per organitzar el Checkbox, Text i Icones
       mainAxisSize: MainAxisSize.min, // Que la Row ocupi el mínim espai horitzontal
       crossAxisAlignment: CrossAxisAlignment.center, // Centrar verticalment els elements
       children: [
         // Col·locar el Checkbox a l'esquerra o a la dreta segons model.checkPosition
          if (model.checkPosition == CheckPosition.left) ...[
            Checkbox(
              value: model.isChecked, // Estat del model
              onChanged: (bool? newValue) { // El onChanged del Checkbox intern ja gestiona el toggle
                _handleTap(); // Cridar el nostre mètode de gestió principal per disparar el callback, etc.
              },
               focusNode: focusNode, // <-- Passem el focusNode del controlador al Checkbox
               // Aplicar estil de focus a la vora del checkbox
               side: MaterialStateBorderSide.resolveWith( // MaterialStateBorderSide permet definir la vora per estats (focus, selected, etc.)
                   (states) {
                     // Quan estigui enfocat, utilitzar el color primary del tema
                     if (states.contains(MaterialState.focused)) {
                       return BorderSide(color: colorScheme.primary, width: 2.0); // Gruix de 2.0 per a focus clar
                     }
                     // Per defecte, utilitzar la vora del tema (InputDecorationTheme o CheckboxTheme)
                     // CheckboxThemeData.side ja defineix la vora per defecte, normalment un OutlineInputBorder.
                     // Però si volem controlar la vora directament aqu , podem fer:
                     // return BorderSide(color: theme.colorScheme.outline, width: 1.0); // Utilitzar color outline del tema
                     return null; // Deixar que el tema CheckboxThemeData defineixi la vora per defecte
                   }
                 ),
                 // Altres propietats de Checkbox si calgués (activeColor, checkColor, shape, etc.)
                 // activeColor: colorScheme.primary, // Color quan està marcat
                 // checkColor: colorScheme.onPrimary, // Color del check interior

            ),
            const SizedBox(width: 8.0), // Espai entre checkbox i text
          ],

          leadingIconWidget, // Icona opcional al principi

          labelWidget, // El text del label

          infoIconWidget, // Icona opcional d'informació a la dreta

           if (model.checkPosition == CheckPosition.right) ...[
            const SizedBox(width: 8.0), // Espai entre text i checkbox
             Checkbox(
              value: model.isChecked, // Estat del model
              onChanged: (bool? newValue) { // El onChanged del Checkbox intern
                _handleTap(); // Cridar el nostre mètode de gestió principal
              },
               focusNode: focusNode, // <-- Passem el focusNode
               // Aplicar estil de focus a la vora del checkbox
               side: MaterialStateBorderSide.resolveWith( // MaterialStateBorderSide permet definir la vora per estats (focus, selected, etc.)
                   (states) {
                     if (states.contains(MaterialState.focused)) {
                       return BorderSide(color: colorScheme.primary, width: 2.0); // Gruix de 2.0 per a focus clar
                     }
                     return null; // Deixar que el tema defineixi la vora per defecte
                   }
                 ),
              // Altres propietats de Checkbox si calgués
            ),
          ],
       ],
     );

     // Envoltem la Row amb un GestureDetector per fer tota l' area interactiva.
     // L'indicador de focus ja s'aplica al Checkbox gràcies al focusNode passat.
     return GestureDetector(
       onTap: _handleTap, // Gesti  del tap a tota l' rea del widget
       behavior: HitTestBehavior.opaque, // Perquè el tap funcioni a tota l' rea de la Row
       child: Padding( // Afegim padding per a l' area de tap i visualitzaci
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Padding vertical per a l' area de tap
          child: checkboxRow, // La Row amb els components
       ),
     );
  }
}