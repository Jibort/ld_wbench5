// lib/ui/widgets/ld_check_box/ld_check_box_model.dart
// Model de dades per al widget LdCheckBox.
// Created: 2025/05/17 ds. GPT(JIQ)
// Updated: 2025/05/18 ds. GEM - Implementació inicial del model.
// Updated: 2025/05/19 dg. CLA - Correcció d'arquitectura, estil i constants mf/cf.

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/widgets/ld_check_box/ld_check_box.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';

/// Model de dades per al widget LdCheckBox.
/// Gestiona l'estat de selecció, el text, les icones i la seva posició.
class LdCheckBoxModel extends LdWidgetModelAbs<LdCheckBox> {

  // MEMBRES ==============================================
  /// Estat de selecció del checkbox (marcat/desmarcat). (mf)
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  set isChecked(bool value) {
    if (_isChecked != value) {
      notifyListeners(() {
        _isChecked = value;
        // Debug.info("$tag: Estat canviat a $value");
      });
    }
  }

  /// Clau de traducció o text literal per a l'etiqueta del checkbox. (cf)
  String _labelSource = '';
  String get labelSource => _labelSource;
  set labelSource(String value) {
    if (_labelSource != value) {
      notifyListeners(() {
        _labelSource = value;
        // Debug.info("$tag: Label source canviat a '$value'");
      });
    }
  }

  /// Paràmetres posicionals per a la traducció del labelSource ({0}, {1}, etc.). (cf)
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

  /// Paràmetres nomenats per a la traducció del labelSource ({name}, {count}, etc.). (cf)
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

  /// Posició de l'indicador de selecció (CheckPosition.left o CheckPosition.right). (cf)
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

  /// Clau de traducció o text literal per a la informació addicional (tooltip/dialog). (cf)
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

  /// Indica si la icona d'informació ha de ser visible. (cf)
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

  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor des d'un mapa de configuració del widget.
  LdCheckBoxModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
    fromMap(pMap);
    Debug.info("$tag: Model creat des de mapa.");
  }

  // MAPEJAT ==============================================
  /// Carrega les dades del model a partir d'un mapa de propietats.
  @override
  void fromMap(MapDyns pMap) {
    super.fromMap(pMap);

    // Carregar propietats específiques de LdCheckBoxModel des del mapa
    // Prioritzar sempre les propietats mf* sobre cf* equivalents quan correspongui
    _isChecked = pMap[mfIsChecked] as bool? ?? 
                 pMap[cfInitialChecked] as bool? ?? 
                 false; // Estat per defecte false
    
    _labelSource = pMap[cfLabel] as String? ?? ''; // Text per defecte buit

    // Arguments de traducció
    _labelPosArgs = pMap[cfLabelPosArgs] as List<String>?;
    _labelNamedArgs = pMap[cfLabelNamedArgs] as LdMap<String>?;

    // Icona
    _leadingIcon = pMap[cfLeadingIcon] as IconData?;

    // Posició del check - Conversió de String a Enum si cal
    final positionString = pMap[cfCheckPosition] as String?;
    _checkPosition = CheckPosition.values.firstWhere(
      (e) => e.toString().split('.').last == positionString,
      orElse: () => CheckPosition.left,
    );

    // Informació addicional
    _infoTextKey = pMap[cfInfoTextKey] as String?;
    _showInfoIcon = pMap[cfShowInfoIcon] as bool? ?? false;

    // Debug.info("$tag: Model carregat des de mapa: isChecked=$_isChecked, labelSource='$_labelSource'");
  }

  /// Converteix les dades del model a un mapa de propietats.
  @override
  MapDyns toMap() {
    MapDyns map = super.toMap();

    // Afegir propietats específiques de LdCheckBoxModel
    map[mfIsChecked] = _isChecked;
    map[cfLabel] = _labelSource;

    // Arguments de traducció
    if (_labelPosArgs != null) map[cfLabelPosArgs] = _labelPosArgs;
    if (_labelNamedArgs != null) map[cfLabelNamedArgs] = _labelNamedArgs;

    // Icona
    if (_leadingIcon != null) map[cfLeadingIcon] = _leadingIcon;

    // Posició del check
    map[cfCheckPosition] = _checkPosition.toString().split('.').last;

    // Informació addicional
    if (_infoTextKey != null) map[cfInfoTextKey] = _infoTextKey;
    map[cfShowInfoIcon] = _showInfoIcon;

    return map;
  }

  // TRADUCCIÓ I FORMAT ===================================
  /// Obté el text del label traduït amb interpolació aplicada.
  String get translatedLabel {
     String translated = _labelSource.tx(_labelPosArgs ?? [], _labelNamedArgs ?? LdMap());
     return translated;
  }

  /// Obté el text de la informació addicional traduït (si infoTextKey no és null).
  String? get translatedInfoText {
     if (_infoTextKey == null) return null;
     String translated = _infoTextKey!.tx();
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