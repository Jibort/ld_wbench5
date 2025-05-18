# Errors Comuns del Projecte Sabina
## Guia per prevenir errors recurrents

---

## 🚨 Errors Arquitecturals

### 1. Confusió Constants cf/mf/ef
```dart
// ❌ ERROR FREQÜENT
map[mfLabel] = _label;  // ús incorrecte de 'mf' per UI

// ✅ CORRECTE
map[cfLabel] = _label;  // 'cf' per configuració UI
```

**Recordatori**:
- `cf`: Configuration Fields (UI del controlador)
- `mf`: Model Fields (dades del negoci)
- `ef`: Event Fields (esdeveniments)

### 2. LdLabels amb Arguments "Congelats" ⭐️
```dart
// ❌ ERROR GREU - Connexió directa
labCounter = LdLabel(pPosArgs: [model.value.toString()]);
model!.attachObserver(labCounter!); // Arguments quedaran congelats!

// ✅ CORRECTE - Function Observer dedicat
late final FnModelObs _obsCounter;

_obsCounter = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == model && mounted) {
    final count = model.counter.toString();
    if (labCounter != null) {
      pfnUpdate();
      setState(() {
        labCounter!.setTranslationArgs(positionalArgs: [count]);
      });
    }
  }
};
model!.attachObserverFunction(_obsCounter);
```

### 3. Modificació Manual en onModelChanged
```dart
// ❌ ERROR - Saltar l'arquitectura
@override
void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
  setState(() {
    (labTime?.model as LdLabelModel).label = newValue; // INCORRECTE!
  });
}

// ✅ CORRECTE - Usar setTranslationArgs
// Fer-ho dins del function observer dedicat
```

### 4. Reconstruccions Excessives amb LdLabels Freqüentment Actualitzats ⭐️

```dart
// ❌ ERROR - Provocar reconstruccions innecessàries de tota la pàgina
_obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == TimeService.s.model && mounted) {
    if (labTime != null) {
      pfnUpdate();
      setState(() { // Això reconstrueix TOTA la pàgina!
        labTime!.setTranslationArgs(positionalArgs: [time]);
      });
    }
  }
};

// ✅ CORRECTE - Aïllar les reconstruccions al LdLabel específic
_obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == TimeService.s.model && mounted) {
    if (labTime != null) {
      pfnUpdate();
      // Això NOMÉS reconstrueix el LdLabel, no tota la pàgina
      labTime!.setTranslationArgsIsolated(positionalArgs: [time]);
    }
  }
};
```

## 💻 Errors de Codi

### 5. Imports amb Paths Relatius
```dart
// ❌ ERROR RECURRENT
import '../../../utils/debug.dart';

// ✅ CORRECTE - Sempre package complet
import 'package:ld_wbench5/utils/debug.dart';
```

### 6. Map vs LdMap en Signatures
```dart
// ❌ ERROR de tipus
static String tx(String key, Map<String, String>? namedArgs);

// ✅ CORRECTE - sempre LdMap
static String tx(String key, LdMap<String>? namedArgs);
```

### 7. Constructor Sense super()
```dart
// ❌ ERROR en constructors
LdButtonModel({required this.label}) : super();

// ✅ CORRECTE - amb paràmetres adequats
LdButtonModel.fromMap(LdMap<dynamic> pMap) : super.fromMap(pMap);
```

### 8. Interfícies Inline Incorrectes
```dart
// ❌ ERROR de sintaxi
LdModelObserverIntf obsTimer = LdModelObserverIntf {
  // NO funciona!
};

// ✅ CORRECTE - funció anònima
LdModelObserverIntf obsTimer = (model, pfnUpdate) {
  // funciona perfectament
};
```

## 📝 Errors de Documentació

### 9. HTML en Comentaris de Documentació
```dart
// ❌ ERROR - HTML directe
/// Exemple: LdMap<String>() causa problemes

// ✅ CORRECTE - HTML escapat
/// Exemple: LdMap&lt;String&gt;() funciona bé
```

### 10. Capçaleres de Fitxer Incompletes
```dart
// ❌ ERROR - Capçalera incompleta
// lib/widgets/button.dart
// Button widget

// ✅ CORRECTE - Capçalera completa
// lib/ui/widgets/ld_button/ld_button.dart
// Botó personalitzat de Sabina
// Created: 2025/05/16 dv. CLA
// Updated: 2025/05/17 ds. CLA - Correcció d'estil
```

### 11. Modificació de Dates de Creació
```dart
// ❌ ERROR - Modificar data de creació
// Created: 2025/05/16 dv. CLA  // Substitueix data original incorrectament

// ✅ CORRECTE - Preservar data de creació, afegir updated
// Created: 2025/05/09 dv. JIQ  // Data original preservada
// Updated: 2025/05/16 dv. CLA - Refactorització del servei
```

## 🧹 Errors d'Organització

### 12. Imports Innecessaris
```dart
// ❌ ERROR - imports no utilitzats
import 'package:ld_wbench5/core/map_fields.dart'; // No s'usa
```

### 13. No Actualitzar map_fields.dart
```dart
// ❌ ERROR - usar constants no definides
map[cfButtonType] = buttonType; // Constant no existeix!

// ✅ CORRECTE - primer afegir la constant
// A map_fields.dart:
const String cfButtonType = 'cf_button_type';
```

### 14. Accessors Redundants
```dart
// ❌ ERROR - duplicar funcionalitat existent
LdButtonModel? get model => ctrl?.model as LdButtonModel?; // Ja al pare!

// ✅ CORRECTE - accessor específic
LdButtonModel? get buttonModel => model as LdButtonModel?;
```

## 🔄 Errors de Traducció

### 15. No Aplicar Traduccions en Botons
```dart
// ❌ ERROR - mostrar clau en lloc de traducció
Text(L.sChangeTheme) // Mostra ##sChangeTheme

// ✅ CORRECTE - aplicar .tx
Text(L.sChangeTheme.tx) // Mostra "Canviar Tema"
```

### 16. Tractament Incorrecte de Múltiples Claus de Traducció
```dart
// ❌ ERROR - No detecta totes les claus de traducció dins d'un text
// El text "Hola ##sWelcome i ##sCounter" no es tradueix completament

// ✅ CORRECTE - Detectar i traduir totes les claus
String result = text;
final matches = _regex.allMatches(result).toList();
for (final match in matches) {
  final key = match.group(0);
  if (key != null) {
    final translated = L.tx(key, posArgs, namedArgs);
    result = result.replaceAll(key, translated);
  }
}
```

### 17. No Separar Traducció d'Interpolació
```dart
// ❌ ERROR - Confusió entre traducció i interpolació
// Traduir i interpolar tot en un pas causa problemes

// ✅ CORRECTE - Separar traducció i interpolació
// 1. Traduir la clau (si és una clau)
// 2. Aplicar interpolació separadament
```

## 📋 Errors de Codificació

### 18. Variables No Utilitzades
**Símptoma**: Declaració de variables de classe que mai s'usen

### 19. Mètodes i Propietats No Implementats
**Símptoma**: Referència a mètodes o propietats que no existeixen

### 20. Ús de Paràmetres Deprecats en Flutter
```dart
// ❌ ERROR
ColorScheme(
  background: colors.background,    // Deprecat
  onBackground: colors.text,        // Deprecat
)

// ✅ CORRECTE
ColorScheme(
  surface: colors.surface,          // Recomanat
  onSurface: colors.text,           // Recomanat
)
```

### 21. Accés a Mapes Sense Verificació
```dart
// ❌ ERROR
ThemeData get darkTheme => _darkThemes[_currentThemeNotifier.value]!;
// Fallarà amb excepció si la clau no existeix

// ✅ CORRECTE
ThemeData get darkTheme {
  final themeName = _currentThemeNotifier.value;
  return _darkThemes.containsKey(themeName) 
    ? _darkThemes[themeName]! 
    : _darkThemes[themeDexeusDark]!;  // Fallback
}
```

### 22. Reconstruccions Innecessàries amb WidgetsBinding.addPostFrameCallback
```dart
// ❌ ERROR - Cicle infinit de reconstrucció
@override
Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _updateControllerReferences(); // Pot causar setState()
  });
  
  return Column(...);
}

// ✅ CORRECTE - Callback únic en initState
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _updateControllerReferences();
  });
}
```

### 23. No Verificar Nul·litat en Models
```dart
// ❌ ERROR - No verificar nul·litat
text = pMap[mfText];  // Error si és null

// ✅ CORRECTE - Garantir valors per defecte
final textValue = pMap[mfText] as String? ?? 
                  pMap[mfInitialText] as String? ?? 
                  "";  // Fallback buit
text = textValue;
```

### 24. Model de Recanvi Insuficient
```dart
// ❌ ERROR - Model de recanvi amb mapa buit
model = LdTextFieldModel.fromMap({}); // Pot fallar

// ✅ CORRECTE - Garantir valors mínims necessaris
MapDyns fallbackConfig = MapDyns();
fallbackConfig[mfText] = ""; // Text buit per defecte
model = LdTextFieldModel.fromMap(fallbackConfig);
```

## 🔧 Errors de Disseny de Serveis

### 25. Duplicitat de Serveis
**Símptoma**: Múltiples serveis amb funcionalitats similars

### 26. Implementació Incorrecta de Singleton
```dart
// ❌ ERROR
static ServeiTemes get s => _inst;  // _inst no definit!

// ✅ CORRECTE
static final ServeiTemes _inst = ServeiTemes._();
static ServeiTemes get s => _inst;
ServeiTemes._(); // Constructor privat
```

### 27. No Dessubscripció d'Observers en dispose()
```dart
// ❌ ERROR - Falta dessubscripció d'observers!

// ✅ CORRECTE
@override
void dispose() {
  model?.detachObserverFunction(_obsCount);
  super.dispose();
}
```

## 🚀 Errors de Rendiment

### 28. Ús Incorrecte de setState() per Actualitzacions Freqüents
**Símptoma**: Tota la UI es reconstrueix innecessàriament
**Solució**: Utilitzar `setTranslationArgsIsolated` per actualitzacions localitzades

### 29. addPostFrameCallback dins de build()
**Símptoma**: Cicles infinits de reconstrucció
**Solució**: Usar només a `initState()` o amb bandera estàtica

## 🎬 Errors en Animacions i Contenidors Plegables ⭐️ (Actualització 19/05/2025)

### 30. No Preservar Widgets Durant Animacions
**Símptoma**: Pèrdua d'estat i excepcions en expandir/contraure contenidors
```dart
// ❌ ERROR - Widgets diferents segons estat
child: containerModel.isExpanded
  ? content  // Widget nou cada vegada
  : SizedBox.shrink(),  // Widget diferent

// ✅ CORRECTE - Pre-construir i preservar
final contentWidget = Padding(
  padding: contentPadding,
  child: content,
);
// ...
child: IgnorePointer(
  ignoring: !containerModel.isExpanded,
  child: contentWidget,  // Sempre el mateix widget
),
```

### 31. Ús de 'null' com Alçada en AnimatedContainer
**Símptoma**: Excepció "Cannot interpolate between finite constraints and unbounded constraints"
```dart
// ❌ ERROR - Alçada null no pot interpolar-se
height: containerModel.isExpanded ? null : 0.0,

// ✅ CORRECTE - Sempre valors finits
height: containerModel.isExpanded ? 300.0 : 0.0,
```

### 32. Alçades Massa Grans en Contenidors Expandibles
**Símptoma**: Error "A RenderFlex overflowed by X pixels on the bottom"
```dart
// ❌ ERROR - Alçada massa gran
return 1000.0;  // Provoca overflow

// ✅ CORRECTE - Alçada raonable + scroll
return 180.0;  // Valor conservador
// I afegir SingleChildScrollView al contingut
```

### 33. No Preservar el Focus en TextFields
**Símptoma**: Els TextFields perden el focus en expandir/contraure
**Solució**:
1. Desar el focus actual abans de l'animació
2. Restaurar-lo després de completar l'animació amb Future.delayed

### 34. No Implementar Recuperació de Models Perduts
**Símptoma**: Models tornant-se null després d'actualitzacions d'estat
```dart
// ❌ ERROR - No detectar models perduts
if (containerModel == null) {
  return Container();  // No recuperació
}

// ✅ CORRECTE - Recuperació automàtica
if (model == null) {
  _createBackupModel(); // Crear model de recanvi
  // Mostrar widget temporal
  return Container(/* Widget temporal */);
}
```

### 35. No Verificar el Model abans d'Operacions
**Símptoma**: Intents d'utilitzar un model null provoquen excepcions
```dart
// ❌ ERROR - Accés a model sense verificació
(model as LdFoldableContainerModel).isExpanded = expanded;

// ✅ CORRECTE - Verificació robusta
final containerModel = model as LdFoldableContainerModel?;
if (containerModel == null) {
  _createBackupModel();
  // Aplicar canvi després de recuperar
  if (model != null) {
    (model as LdFoldableContainerModel).isExpanded = expanded;
  }
  return;
}
```

### 36. Gestió Inadequada d'Amplada en Contenidors
**Símptoma**: Contingut no ocupa tota l'amplada disponible
**Solució**:
1. Aplicar `width: double.infinity` als contenidors
2. Usar `crossAxisAlignment: CrossAxisAlignment.stretch` en Columns
3. Aplicar `widthFactor: 1.0` en Align widgets

---

## 👤 Errors Específics de JIQ
1. Oblidar aplicar traduccions (.tx) en textos
2. Configuració incorrecta de LdLabels reactius
3. Tendència a modificar directament els models
4. Ús inconsistent de constants

## ⚠️ Notes Importants
- Aplicar **doble revisió obligatòria** abans d'entregar qualsevol codi
- Utilitzar `setTranslationArgsIsolated` per components freqüentment actualitzats
- Comentaris `//JIQ>CLA:` s'han de processar i eliminar automàticament
- Preservar sempre els mateixos widgets en animacions d'expansió/contracció
- Mai utilitzar alçada `null` en AnimatedContainer
- Sempre implementar recuperació de models perduts en components complexos
- Preservar i restaurar el focus en animacions que afecten TextFields

*Aquest document es revisa i actualitza constantment amb nous errors descoberts durant el desenvolupament del projecte Sabina.*