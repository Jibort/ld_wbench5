// lib/ui/widgets/ld_check_box/ld_check_box.dart
// Widget de Checkbox personalitzat amb suport per a traducció, icones i indicador de focus.
// Created: 2025/05/17 ds. GPT(JIQ)
// Updated: 2025/05/18 ds. GEM - Implementaci  inicial del widget.
// Updated: 2025/05/18 ds. GEM - Correcció de constants mf/cf per label i afegides noves cf.
// Updated: 2025/05/18 ds. GEM - Definició única de CheckPosition i exportació.

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart'; // Importar les constants cf/mf
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box_ctrl.dart'; // Importar controlador
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box_model.dart'; // Importar model

// Exportem els altres fitxers del widget perquè siguin accessibles des de fora del directori.
export 'ld_check_box_ctrl.dart';
export 'ld_check_box_model.dart';
export 'package:ld_wbench5/core/map_fields.dart'; // Exportar constants rellevants si s'utilitzen directament des de fora

// Definici  única de l'enum CheckPosition aqu , ja que aquest  s el fitxer públic del widget.
/// Defineix la posici  de l'indicador de selecci  (el quadrat del checkbox).
enum CheckPosition { left, right }

/// Widget de Checkbox personalitzat segons l'arquitectura Sabina.
/// Proporciona opcions per a posici  del check, icones i informaci  addicional.
class LdCheckBox extends LdWidgetAbs {

  // CONSTRUCTOR PRINCIPAL =================================
  /// Constructor.
  LdCheckBox({
    Key? key,
    super.pTag,
    bool initialChecked = false, // Estat inicial (config) - Utilitza cfInitialChecked
    required String labelText, // Text o clau de traducci  per al label (config) - Utilitza cfLabel
    List<String>? labelPosArgs, // Arguments posicionals per al label (config) - Utilitza cfLabelPosArgs
    LdMap<String>? labelNamedArgs, // Arguments nomenats per al label (config) - Utilitza cfLabelNamedArgs
    IconData? leadingIcon, // Icona opcional abans del text (config) - Utilitza cfLeadingIcon
    CheckPosition checkPosition = CheckPosition.left, // Posici  del check (esquerra per defecte) (config) - Utilitza cfCheckPosition
    String? infoTextKey, // Text o clau per a la informaci  addicional (config) - Utilitza cfInfoTextKey
    bool showInfoIcon = false, // Mostrar la icona d'informaci  (config) - Utilitza cfShowInfoIcon
    Function(bool)? onToggled, // Callback quan l'estat canvia (event) - Utilitza efOnToggled
    VoidCallback? onInfoTapped, // Callback quan es prem la icona d'informaci (event) - Utilitza efOnInfoTapped
    bool isVisible = true, // Propietat base (config) - Utilitza cfIsVisible
    bool isEnabled = true, // Propietat base (config) - Utilitza cfIsEnabled
    bool canFocus = true, // Propietat base (config) - Utilitza cfCanFocus
  }) : super(pKey: key, pConfig: {
          // Propietats base (cf*)
          cfTag: pTag, // Passar el tag a la configuraci
          cfIsVisible: isVisible,
          cfIsEnabled: isEnabled, // Controla si el checkbox  s interactiu
          cfCanFocus: canFocus, // Controla si el checkbox pot rebre focus

          // Propietats de Configuració (cf*)
          cfInitialChecked: initialChecked, // <-- Associa l'estat inicial a una constant cf
          cfLabel: labelText, // Utilitzem cfLabel per al text del label
          cfLabelPosArgs: labelPosArgs,
          cfLabelNamedArgs: labelNamedArgs,
          cfLeadingIcon: leadingIcon,
          cfCheckPosition: checkPosition.toString().split('.').last, // Guardem l'enum com a String
          cfInfoTextKey: infoTextKey,
          cfShowInfoIcon: showInfoIcon,

          // Propietats d'Events (ef*)
          efOnToggled: onToggled,
          efOnInfoTapped: onInfoTapped,

          // Note: El model tindr  una propietat mfIsChecked que carregar  el seu estat inicial
          // des de cfInitialChecked al m tode fromMap del model, i després gestionar  els canvis.

        }) {
     // logs inicials si calgu s
     // Debug.info("$tag: Widget LdCheckBox creat amb label: '$labelText', initialChecked: $initialChecked");
  }

  // CONSTRUCTOR FROM MAP (Opcional) =======================
  // Si necessitem crear el widget a partir d'un mapa extern.
   LdCheckBox.fromMap(MapDyns configMap) : super(pConfig: configMap) {
      // El constructor base ja s'encarrega de processar el mapa.
      // Debug.info("$tag: Widget LdCheckBox creat des d'un mapa.");
   }


  // CONTROLADOR ASSOCIAT ==================================
  @override
  LdWidgetCtrlAbs createCtrl() {
    return LdCheckBoxCtrl(this);
  }

  // ACCÉS AL CONTROLADOR I MODEL AMB TIPUS SEGUR ===========
  /// Accés ràpid al controlador amb tipus segur.
  LdCheckBoxCtrl? get checkboxCtrl => ctrl as LdCheckBoxCtrl?;
  /// Accés ràpid al model amb tipus segur.
  LdCheckBoxModel? get checkboxModel => model as LdCheckBoxModel?;


  // MÈTODES D'ACTUALITZACIÓ (per control programàtic des de fora) =
  /// Estableix programàticament l'estat de selecció del checkbox.
  /// Aquesta acció notificarà al model i als seus observadors (inclòs el controlador).
  void setChecked(bool value) => checkboxModel?.setChecked(value);

  /// Obté l'estat de selecció actual des del model.
  bool get isChecked => checkboxModel?.isChecked ?? false;

   /// Alterna programàticament l'estat de selecció.
   /// Aquesta acció notificarà al model i als seus observadors (inclòs el controlador).
   void toggle() => checkboxModel?.toggle();

   /// Actualitza els arguments de traducció del label.
   /// Aquesta acció notificarà al model i als seus observadors.
   void updateLabelArgs({
     List<String>? positionalArgs,
     LdMap<String>? namedArgs,
   }) => checkboxModel?.updateLabelArgs(positionalArgs: positionalArgs, namedArgs: namedArgs);


  // PROPIETATS DE CONFIGURACIÓ (Accés als valors del mapa de configuració original) =
   // Aquests getters llegeixen directament del mapa de configuraci  original del widget.
   // S n útils si el controlador o altres parts necessiten consultar la config original
   // sense passar pel model (que gestiona l'estat i pot tenir valors per defecte o processats).
   // Exemple:
   // bool get showInfoIconConfig => config[cfShowInfoIcon] as bool? ?? false;
   // String? get infoTextKeyConfig => config[cfInfoTextKey] as String?;

   // Per ara, els getters del model (que llegeixen del seu propi estat carregat de la config inicial)
   // i les refer ncies directes a config[cf...] en el controlador s n suficients.

}