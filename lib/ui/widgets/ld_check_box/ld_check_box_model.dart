// lib/ui/widgets/ld_check_box/ld_check_box_model.dart
// Model de dades per al widget LdCheckBox.
// Created: 2025/05/17 ds. GPT(JIQ)
// Updated: 2025/05/18 ds. GEM - Implementaci  inicial del model.
// Updated: 2025/05/18 ds. GEM - Correcció de constants mf/cf per label.
// Updated: 2025/05/18 ds. GEM - Eliminació de la definició duplicada de CheckPosition.

import 'package:flutter/material.dart'; // Necessari per IconData, etc.
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box.dart'; // Importar el widget associat (inclou CheckPosition)
import 'package:ld_wbench5/core/extensions/string_extensions.dart'; // Per .tx()

// Eliminem la definició duplicada de CheckPosition aquí.
// enum CheckPosition { left, right }


/// Model de dades per al widget LdCheckBox.
/// Gestiona l'estat de selecci , el text, les icones i la seva posici .
class LdCheckBoxModel extends LdWidgetModelAbs<LdCheckBox> {

  // MEMBRES ==============================================
  /// Estat de selecci  del checkbox (marcat/desmarcat). (mf)
  // Utilitza la constant mfIsChecked
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  set isChecked(bool value) {
    if (_isChecked != value) {
      notifyListeners(() {
        _isChecked = value;
        // Debug.info("$tag: Estat canviat a $value"); // Log de depuraci  pot ser redundant amb el controlador
      });
    }
  }

  /// Clau de traducci  o text literal per a l'etiqueta del checkbox. (cf)
  // Utilitza la constant cfLabel
  String _labelSource = ''; // Canviem el nom intern per evitar confusi  amb el text tradu t
  String get labelSource => _labelSource;
  set labelSource(String value) {
    if (_labelSource != value) {
      notifyListeners(() {
        _labelSource = value;
        // Debug.info("$tag: Label source canviat a '$value'");
      });
    }
  }

  /// Par metres posicionals per a la traducci  del labelSource ({0}, {1}, etc.). (cf)
  // Utilitza la constant cfLabelPosArgs
  List<String>? _labelPosArgs;
  List<String>? get labelPosArgs => _labelPosArgs;
  set labelPosArgs(List<String>? value) {
    if (_labelPosArgs != value) {
      notifyListeners(() {
        _labelPosArgs = value;
        // Debug.info("$tag: Label positional args canviats");
      });
    }
  }

   /// Par metres nomenats per a la traducci  del labelSource ({name}, {count}, etc.). (cf)
  // Utilitza la constant cfLabelNamedArgs
  LdMap<String>? _labelNamedArgs;
  LdMap<String>? get labelNamedArgs => _labelNamedArgs;
  set labelNamedArgs(LdMap<String>? value) {
    if (_labelNamedArgs != value) {
      notifyListeners(() {
        _labelNamedArgs = value;
        // Debug.info("$tag: Label named args canviats");
      });
    }
  }


  /// Icona opcional a mostrar abans del text (a l'esquerra de l'etiqueta). (cf)
  // Utilitza la constant cfLeadingIcon
  IconData? _leadingIcon;
  IconData? get leadingIcon => _leadingIcon;
  set leadingIcon(IconData? value) {
     if (_leadingIcon != value) {
       notifyListeners(() {
         _leadingIcon = value;
         // Debug.info("$tag: Leading icon canviada");
       });
     }
  }


  /// Posici  de l'indicador de selecci  (CheckPosition.left o CheckPosition.right). (cf)
  // Utilitza la constant cfCheckPosition
  CheckPosition _checkPosition = CheckPosition.left; // Per defecte a l'esquerra
  CheckPosition get checkPosition => _checkPosition;
  set checkPosition(CheckPosition value) {
    if (_checkPosition != value) {
      notifyListeners(() {
        _checkPosition = value;
        // Debug.info("$tag: Check position canviada a $value");
      });
    }
  }

  /// Clau de traducci  o text literal per a la informaci  addicional (tooltip/dialog). (cf)
  // Utilitza la constant cfInfoTextKey
  String? _infoTextKey;
  String? get infoTextKey => _infoTextKey;
   set infoTextKey(String? value) {
     if (_infoTextKey != value) {
       notifyListeners(() {
         _infoTextKey = value;
         // Debug.info("$tag: Info text key canviada a '$value'");
       });
     }
  }


  /// Indica si la icona d'informaci  ha de ser visible. (cf)
  // Utilitza la constant cfShowInfoIcon
  bool _showInfoIcon = false;
   bool get showInfoIcon => _showInfoIcon;
   set showInfoIcon(bool value) {
     if (_showInfoIcon != value) {
       notifyListeners(() {
         _showInfoIcon = value;
         // Debug.info("$tag: Show info icon canviat a $value");
       });
     }
  }

   /// Callback a executar quan es prem la icona d'informaci .
   // Aquesta no  s una propietat del model, sin  una configuraci  del widget/controlador.
   // No l'incloem aqu .

  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor des d'un mapa de configuraci  del widget.
  LdCheckBoxModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
    fromMap(pMap); // Carregar les dades espec fiques del model des del mapa inicial
     Debug.info("$tag: Model creat des de mapa.");
  }

  // MAPEJAT ==============================================
  /// Carrega les dades del model a partir d'un mapa de propietats.
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap); // Carregar propietats base

    // Carregar propietats espec fiques de LdCheckBoxModel des del mapa (mf* i cf* rellevants per a l'estat/config del model)
    _isChecked = pMap[mfIsChecked] as bool? ?? false; // Estat per defecte false (mf)
    _labelSource = pMap[cfLabel] as String? ?? ''; // Text per defecte buit (cf) - Utilitzem cfLabel

    // Arguments de traducci  (cf*)
    _labelPosArgs = pMap[cfLabelPosArgs] as List<String>?; // Permetre null
    _labelNamedArgs = pMap[cfNamedArgs] as LdMap<String>?; // Permetre null

    // Icona (cf*)
    _leadingIcon = pMap[cfLeadingIcon] as IconData?; // Permetre null

    // Posici  del check (cf*) - Conversió de String a Enum si cal
    final positionString = pMap[cfCheckPosition] as String?;
    _checkPosition = CheckPosition.values.firstWhere(
      (e) => e.toString().split('.').last == positionString,
      orElse: () => CheckPosition.left, // Posici  per defecte esquerra
    );

    // Informaci  addicional (cf*)
    _infoTextKey = pMap[cfInfoTextKey] as String?; // Permetre null
    _showInfoIcon = pMap[cfShowInfoIcon] as bool? ?? false; // Per defecte no mostrar

    // Debug.info("$tag: Model carregat des de mapa: isChecked=$_isChecked, labelSource='$_labelSource', checkPosition=$_checkPosition, showInfoIcon=$_showInfoIcon");
  }

  /// Converteix les dades del model a un mapa de propietats.
  @override
  MapDyns toMap() {
    MapDyns map = super.toMap(); // Incloure propietats base

    // Afegir propietats espec fiques de LdCheckBoxModel (mf* i cf* rellevants per a l'estat/config del model)
    map[mfIsChecked] = _isChecked; // (mf)
    map[cfLabel] = _labelSource; // (cf) - Utilitzem cfLabel

    // Arguments de traducci  (cf*)
    if (_labelPosArgs != null) map[cfLabelPosArgs] = _labelPosArgs;
    if (_labelNamedArgs != null) map[cfNamedArgs] = _labelNamedArgs;

    // Icona (cf*)
     if (_leadingIcon != null) map[cfLeadingIcon] = _leadingIcon;

    // Posici  del check (cf*)
    map[cfCheckPosition] = _checkPosition.toString().split('.').last;

    // Informaci  addicional (cf*)
     if (_infoTextKey != null) map[cfInfoTextKey] = _infoTextKey;
     map[cfShowInfoIcon] = _showInfoIcon;


    // Debug.info("$tag: Model convertit a mapa: $map");
    return map;
  }

   // GESTI  DE CAMPS (Opcional, si es vol acc s din mic per clau) =================
   // Implementaci  similar a LdTextFieldModel o LdAppBarModel si fos necessari.
   // Per ara, els setters/getters directes s n suficients.

   // TRADUCCIÓ I FORMAT ===================================
   /// Obté el text del label traduït amb interpolació aplicada.
   String get translatedLabel {
      String translated = _labelSource.tx(_labelPosArgs ?? [], _labelNamedArgs ?? LdMap()); // Utilitzem labelSource
      // Debug.info("$tag: Translated label: '$_labelSource' -> '$translated'");
      return translated;
   }

   /// Obté el text de la informació addicional traduït (si infoTextKey no és null).
   String? get translatedInfoText {
      if (_infoTextKey == null) return null;
       // La icona d'informació no sol tenir interpolació d'arguments propis,
       // però si la necessités, hauríem d'afegir camps per a infoPosArgs/infoNamedArgs.
      String translated = _infoTextKey!.tx();
      // Debug.info("$tag: Translated info text: '$_infoTextKey' -> '$translated'");
      return translated;
   }


  // FUNCIONALITAT ESPECÍFICA =============================
  /// Alterna l'estat de selecció del checkbox.
  void toggle() {
    isChecked = !_isChecked; // Utilitza el setter per notificar
  }

   /// Actualitza l'estat de selecció. Útil si l'estat ve de fora.
   void setChecked(bool value) {
     isChecked = value; // Utilitza el setter per notificar
   }

   /// Actualitza només els arguments de traducció del label.
   void updateLabelArgs({
     List<String>? positionalArgs,
     LdMap<String>? namedArgs,
   }) {
     notifyListeners(() {
       if (positionalArgs != null) {
         _labelPosArgs = positionalArgs;
       }
       if (namedArgs != null) {
         _labelNamedArgs = namedArgs;
       }
       // Debug.info("$tag: Arguments de traducció del label actualitzats.");
     });
   }

}