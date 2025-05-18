# Normes d'Estil i Codificació - Projecte Sabina

## 1. Estructura de Fitxers i Capçaleres

### Format de Capçalera de Fitxer
Sempre iniciem els fitxers amb:
1. **Camí i nom absolut** del fitxer dins el projecte
2. **Breu descripció** de la funcionalitat
3. **Data de creació**: `Created: (YYYY/MM/DD dx. sigles)`
   - `dx`: sigles del dia (`dl` dilluns, `dt` dimarts, `dc` dimecres, etc.)
   - `sigles`: programador (`JIQ` Jordi, `CLA` Claude, `GPT` ChatGPT)
   - `[...]` al voltant de sigles indica correccions posteriors
4. **Línies d'actualització**: `Updated: ...` amb mateix format

```dart
// lib/ui/pages/test_page/test_page_ctrl.dart
// Controlador de la pàgina de prova que mostra la implementació simplificada.
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/08 dj. CLA - Actualitzat per utilitzar LdTheme
```

### Preservació de Dates Originals
En cas de modificar un fitxer existent:
- **MAI modificar** la línia `Created:` original
- **Afegir** una nova línia `Updated:` amb la data actual i descripció del canvi
- **Mantenir** l'historial d'actualitzacions per traçabilitat

```dart
// Created: 2025/05/09 dv. JIQ  
// Updated: 2025/05/16 dv. CLA - Refactorització del servei de temes  
```

## 2. Estructura i Organització de Codi

### Organització d'Imports
Separar amb línies en blanc en blocs:
1. **Dart/Flutter core packages**
2. **Llibreries externes**
3. **Projecte propi** (per ordre alfabètic)

```dart
import 'package:flutter/material.dart';

import 'package:external_package/external.dart';

import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/utils/debug.dart';
```

### Declaracions de Classe
Dedicar una línia independent a '[abstract] class', 'extends', 'with', 'on' i 'implements' en la
declaració d'una classe.

Alinear a la columna lliure més a la dreta:
```dart
class      TestPageCtrl 
extends    LdPageCtrlAbs<TestPage>
implements LdModelObserverIntf {
```

### Seccions de Codi
Agrupar lògicament amb capçaleres:
```dart
// MEMBRES ESTÀTICS =====================================
// GETTERS/SETTERS ESTÀTICS =============================
// GETTERS/SETTERS ESTÀTICS =============================
// MEMBRES ==============================================
// CONSTRUCTORS/DESTRUCTORS =============================
// GETTERS/SETTERS ======================================
// IMPLEMENTACIÓ 'Interface' ============================
// FUNCIONALITAT ========================================
```
Format: Nom en majúscules + espai + '=' fins columna 60

## 3. Nomenclatura i Constants

### Sistema de Constants (cf/mf/ef)
- **cf** (Configuration Fields): Camps UI del controlador
- **mf** (Model Fields): Camps de dades del negoci
- **ef** (Event Fields): Camps d'esdeveniments

```dart
// Configuration (UI)
const String cfLabel = 'cf_label';
const String cfIsEnabled = 'cf_is_enabled';

// Model (dades)
const String mfTitle = 'mf_title';
const String mfCounter = 'mf_counter';

// Events
const String efOnPressed = 'ef_on_pressed';
```

### Nomenclatura de Fitxers
- Widgets: `ld_{component}_widget.dart`
- Controllers: `ld_{component}_ctrl.dart`
- Models: `ld_{component}_model.dart`
- Extensions: `{type}_extensions.dart`
- Serveis: `{name}_service.dart`

### Alineació de Variables
Alinear operador '=' a una columna consistent:
```dart
final String tagLabCounter = LdTaggableMixin.customTag("labCounter");
final String tagLabLocale  = LdTaggableMixin.customTag("labLocale");
final String tagLabTime    = LdTaggableMixin.customTag("labTime");
```

## 4. Nomenclatura de Paràmetres

### Prefixos de Paràmetres
- **`pX`**: Paràmetres generals
- **`pfnY`**: Paràmetres funció/callback
- **`pKey`**: Claus de propietats
- **`pValue`**: Valors de propietats

```dart
void setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg}) {
  // ...
}

void _obsCounter = (LdModelAbs pModel, void Function() pfnUpdate) {
  // ...
};
```

## 5. Imports i Referències

### Imports amb Package Complet
**SEMPRE** usar package complet, **MAI** paths relatius:
```dart
// ✅ CORRECTE
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/ld_map.dart';

// ❌ INCORRECTE  
import '../../../utils/debug.dart';
import '../../core/ld_map.dart';
```

## 6. Tipus i Interfícies

### Ús de LdMap vs Map
Sempre usar `LdMap<T>` en signatures i declaracions:
```dart
// ✅ CORRECTE
static String tx(String key, LdMap<String>? namedArgs);
void updateData(LdMap<dynamic> data);

// ❌ INCORRECTE
static String tx(String key, Map<String, String>? namedArgs);
void updateData(Map<String, dynamic> data);
```

### Interfícies Inline (Funcionals)
```dart
// ✅ CORRECTE - Funció anònima
LdModelObserverIntf obsTimer = (model) {
  // lògica inline
};

// ✅ CORRECTE - Callback funcional  
void Function(LdModelAbs, void Function()) obsTimer = (model, pfUpdate) {
  // lògica inline
};
```

## 7. Constructors i Mètodes

### Constructors
Sempre cridar `super()` amb paràmetres adequats:
```dart
// ✅ CORRECTE
LdButtonModel.fromMap(LdMap<dynamic> pMap) : super.fromMap(pMap);

// ❌ INCORRECTE
LdButtonModel({required this.label}) : super();
```

### Documentació de Classes
```dart
/// Classe base per a tots els models de widgets
/// 
/// Proporciona funcionalitat comuna com:
/// - Gestió d'observers
/// - Serialització/deserialització
/// - Notificacions de canvis
abstract class LdWidgetModelAbs<T extends LdWidgetAbs> {
```

## 8. Errors Comuns a Evitar

### Confusió de Constants
```dart
// ❌ Error - usar mf per UI
map[mfLabel] = _label;  // mf és per dades del negoci

// ✅ Correcte - usar cf per UI  
map[cfLabel] = _label;  // cf és per configuració UI
```

### HTML en Comentaris
```dart
// ❌ Error - HTML directe
/// Exemple: LdMap<String>() causa problemes

// ✅ Correcte - HTML escapat
/// Exemple: LdMap&lt;String&gt;() funciona bé
```

### Imports Innecessaris
No deixar imports que no s'utilitzen.

### Accessors Redundants
No duplicar funcionalitat existent del pare.

## 9. Patró Específic: LdLabels Reactius ⭐️

### Regla d'Or
> **Qualsevol LdLabel que mostri dades que canvien SEMPRE necessita un function observer dedicat que actualitzi els arguments de traducció manualment via setTranslationArgs() o setTranslationArgsIsolated().**

### Template Estàndard
```dart
/// Observer per gestionar LdLabels amb dades dinàmiques
late final FnModelObs _obs{ComponentName};

@override
void initialize() {
  // 1. Crear LdLabel amb arguments inicials
  {labelInstance} = LdLabel(
    pLabel: {translationKey},
    pPosArgs: [{initialValue}],
  );
  
  // 2. Crear function observer per actualitzar arguments
  _obs{ComponentName} = (LdModelAbs pModel, void Function() pfnUpdate) {
    if (pModel == {sourceModel} && mounted) {
      final {data} = ({sourceModel} as {ModelType}).{dataGetter};
      
      if ({labelInstance} != null) {
        pfnUpdate();
        
        // Per components que s'actualitzen freqüentment, usar:
        {labelInstance}!.setTranslationArgsIsolated(positionalArgs: [{data}]);
        
        // Per components que s'actualitzen rarament, usar:
        // setState(() {
        //   {labelInstance}!.setTranslationArgs(positionalArgs: [{data}]);
        // });
      }
    }
  };
  
  // 3. Connectar function observer (NO el LdLabel directament)
  {sourceModel}.attachObserverFunction(_obs{ComponentName});
}

@override
void dispose() {
  // 4. IMPORTANT: desconnectar observer
  {sourceModel}?.detachObserverFunction(_obs{ComponentName});
  super.dispose();
}
```

### Cas especial per dades que canvien freqüentment

Per components amb dades que canvien molt freqüentment (com el TimeService), és crucial utilitzar `setTranslationArgsIsolated` en lloc de `setTranslationArgs` per evitar reconstruccions innecessàries del widget pare:

```dart
_obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == TimeService.s.model && mounted) {
    final time = TimeService.s.model.formattedTime;
    
    if (labTime != null) {
      pfnUpdate();
      
      // IMPORTANT: Utilitzar setTranslationArgsIsolated
      // per evitar reconstruccions innecessàries de tota la pàgina
      labTime!.setTranslationArgsIsolated(positionalArgs: [time]);
    }
  }
};
```

### Errors Freqüents amb LdLabels
```dart
// ❌ Error greu - Connexió directa
labCounter = LdLabel(pPosArgs: [model.value.toString()]);
model!.attachObserver(labCounter!); // Arguments "congelats"

// ❌ Error - Modificació manual en onModelChanged
@override
void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
  setState(() {
    (labTime?.model as LdLabelModel).label = newValue; // Salta l'arquitectura
  });
}

// ❌ Error - Provocar reconstruccions innecessàries de tota la pàgina
_obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (labTime != null) {
    setState(() {
      labTime!.setTranslationArgs(positionalArgs: [time]);
    });
  }
};
```

## 10. Sistema de Traduccions

### Claus de Traducció
- Prefix `##` per identificar claus
- Extensions String per simplificar ús
```dart
// Extensions disponibles
"##sCurrentTime".tx                           // Traducció simple
"##sCounter".txWith(["5"])                   // Amb paràmetres posicionals  
"##sWelcome".txArgs({"name": "Joan"})        // Amb paràmetres nomenats
"##sComplex".txFull(["Joan"], {"count": "5"}) // Combinat
```

### Detecció de Múltiples Claus
El sistema de traduccions ha de ser capaç de detectar i traduir correctament múltiples claus dins d'un mateix text:

```dart
// ✅ CORRECTE - Detecció i traducció de múltiples claus en un text
String tx(String text) {
  String result = text;
  
  // Buscar totes les claus de traducció (##...)
  final matches = _regex.allMatches(result).toList();
  
  for (final match in matches) {
    final key = match.group(0);
    if (key != null) {
      // Traduir aquesta clau específica
      final translated = L.tx(key, posArgs, namedArgs);
      // Substituir només aquesta clau
      result = result.replaceAll(key, translated);
    }
  }
  
  // Aplicar interpolació global després de traduir totes les claus
  return StringTx.applyInterpolation(result, posArgs, namedArgs);
}
```

### Gestió de Valors Nuls en Models
Sempre garantir valors per defecte per evitar errors de tipus en LdTextField i altres models:

```dart
// ✅ CORRECTE - Gestió de nul·litat en LdTextFieldModel
LdTextFieldModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
  // Garantir que text mai sigui null
  final textValue = pMap[mfText] as String? ?? 
                    pMap[mfInitialText] as String? ?? 
                    "";  // Valor per defecte buit
  text = textValue;
}
```

## 11. Comentaris de Comunicació Interna

### Format per Notes entre Desenvolupadors
```dart
//JIQ>CLA: Observa que sempre separo amb una línia en blanc els imports per blocs
//JIQ>CLA: aquestes línies s'esborren quan ja no fan falta
```

Aquestes línies NO pertanyen al codi sinó a la comunicació entre desenvolupadors i s'han d'esborrar quan perden sentit.

## 12. Procés de Revisió de Codi

### Doble Revisió Obligatòria
**Sempre** cal fer una segona revisió abans d'entregar qualsevol codi per assegurar que es compleixen totes les normes d'estil.

#### Procediment de Revisió
- **Primera passada**: Escriure el codi seguint totes les normes d'estil
- **Segona revisió**: Verificar que s'han aplicat correctament totes les normes abans d'entregar el codi

#### Checklist de Revisió
- ✅ **Imports organitzats**: core → external → projecte (amb línies en blanc)
- ✅ **Constants correctes**: cf/mf/ef segons la funcionalitat
- ✅ **Package complet**: sempre `package:ld_wbench5/...` (mai paths relatius)
- ✅ **Tipus adequats**: `LdMap<T>` enlloc de `Map<String, T>`
- ✅ **Prefixos de paràmetres**: `pX` per generals, `pfnY` per callbacks
- ✅ **Capçaleres de fitxer**: camí, descripció, Created/Updated complets
- ✅ **Seccions de codi**: organitzades amb capçaleres fins columna 60
- ✅ **Alineacions**: variables i declarations alineades consistentment
- ✅ **LdLabels reactius**: amb function observers dedicats (no connexió directa)
- ✅ **Constructors**: sempre amb `super()` adequat
- ✅ **Documentació**: comentaris de classes amb `///` i descripció completa
- ✅ **Optimitzacions**: ús de `setTranslationArgsIsolated` per actualitzacions freqüents
- ✅ **Traduccions múltiples**: detectar i traduir totes les claus dins d'un text
- ✅ **Gestió de nul·litat**: verificar fallbacks i valors per defecte als models

#### Norma Especial: Comentaris de Comunicació
Els comentaris `//JIQ>CLA:` s'han de llegir, entendre, aplicar i **eliminar automàticament** després de ser processats.

## 13. Refactorització de Serveis

### Criteri de Migració de Serveis
- En cas de duplicitat de serveis, sempre es mantindrà:
  1. El servei més complet
  2. El que segueixi millor l'arquitectura del projecte
  3. El que tingui menys dependències externes

### Gestió de Temes
- `ThemeService` és ara l'únic servei per gestionar temes
- Qualsevol referència a `LdTheme` ha de ser substituïda per `ThemeService`
- Mantenir la mateixa interfície pública i funcionalitats

### Patró per a Serveis Reactius
- Usar `ValueNotifier` per a gestionar canvis d'estat
- Implementar mètodes de notificació explícits (ex: `_notifyThemeChanged()`)
- Assegurar implementació completa del patró singleton

## 14. Gestió d'APIs Obsoletes/Deprecades

### Actualització de Paràmetres Flutter
- Revisar periòdicament paràmetres deprecats en Flutter
- Substituir `background` per `surface` a ColorScheme
- Substituir `onBackground` per `onSurface` a ColorScheme
- Usar `scaffoldBackgroundColor` en lloc de `background`

### Implementació de Fallbacks Robustos
- Prevenir excepcions amb comprovacions de nul·litat
- Proporcionar valors per defecte quan sigui necessari
- Implementar mecanismes de fallback per garantir l'estabilitat
```dart
// ✅ CORRECTE - Amb fallback
ThemeData get darkTheme {
  final themeName = _currentThemeNotifier.value;
  return _darkThemes.containsKey(themeName) 
    ? _darkThemes[themeName]! 
    : _darkThemes[defaultThemeName]!;
}

// ❌ INCORRECTE - Sense fallback  
ThemeData get darkTheme => _darkThemes[_currentThemeNotifier.value]!;
```

## 15. Optimitzacions de Rendiment

### Aïllament de Reconstruccions
- Per components que s'actualitzen freqüentment, aïllar les reconstruccions utilitzant `setTranslationArgsIsolated` en lloc de `setState` al nivell del controlador pare.
- Evitar reconstruir widgets pare innecessàriament.

### Gestió de Timers i Components d'Alta Freqüència
- Limitar les reconstruccions només als components afectats.
- No forçar reconstrucció de widgets complexos per canvis petits en un sol element.

### Ús Correcte de WidgetsBinding.addPostFrameCallback
- **Mai** cridar `addPostFrameCallback` dins de `build()` o mètodes que es criden freqüentment.
- Utilitzar només a `initState()` o amb bandera estàtica per evitar reconstruccions infinites.

```dart
// ✅ CORRECTE - A initState
@override
void initState() {
  super.initState();
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _updateControllerReferences();
  });
}

// ✅ ALTERNATIVA - Amb bandera estàtica
static bool _controllersInitialized = false;

@override
Widget buildPage(BuildContext context) {
  if (!_controllersInitialized) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllerReferences();
      _controllersInitialized = true;
    });
  }
  
  // ... resta del codi
}
```

## 16. Creació Robusta de Models

### Gestió de Valors per Defecte
Sempre proporcionar valors per defecte segurs en la creació de models:

```dart
// ✅ CORRECTE - Constructor robust de LdTextFieldModel
LdTextFieldModel.fromMap(MapDyns pMap) : super.fromMap(pMap) {
  // Valors per defecte explícits
  final textValue = pMap[mfText] as String? ?? 
                    pMap[mfInitialText] as String? ?? 
                    "";  // Fallback buit
  text = textValue;
}
```

### Models de Recanvi Adequats
Garantir que els models de recanvi (en cas d'error) tinguin valors mínims necessaris:

```dart
// ✅ CORRECTE - Creació de model de recanvi
try {
  model = LdTextFieldModel.fromMap(widget.config);
} catch (e) {
  Debug.error("$tag: Error creant model: $e");
  
  // Garantir valors mínims necessaris
  MapDyns fallbackConfig = MapDyns();
  fallbackConfig[mfText] = ""; // Text buit per defecte
  
  model = LdTextFieldModel.fromMap(fallbackConfig);
}
```

## 17. Animacions i Contenidors Plegables ⭐️

### Preservació de Widgets Durant Animacions
En components amb animacions d'expansió/contracció, **SEMPRE** preservar els mateixos widgets fills en ambdós estats per evitar reconstruccions:

```dart
// ✅ CORRECTE - Pre-construir el contingut
final contentChild = Padding(
  padding: contentPadding,
  child: content,
);

// AnimatedContainer amb el contingut
AnimatedContainer(
  duration: _animationDuration,
  height: containerModel.isExpanded ? maxExpandedHeight : 0.0,
  child: AnimatedOpacity(
    opacity: containerModel.isExpanded ? 1.0 : 0.0,
    // IMPORTANT: Mateix widget en ambdós casos
    child: IgnorePointer(
      ignoring: !containerModel.isExpanded,
      child: contentChild, // Sempre el mateix widget
    ),
  ),
)

// ❌ INCORRECTE - Widgets diferents segons estat
AnimatedContainer(
  duration: _animationDuration,
  height: containerModel.isExpanded ? null : 0.0,
  child: containerModel.isExpanded
    ? content // Widget A
    : SizedBox.shrink(), // Widget B (diferent!)
)
```

### Animació d'Alçada Segura
**MAI** utilitzar `null` com a valor d'alçada en un AnimatedContainer:

```dart
// ✅ CORRECTE - Alçada finita per a AnimatedContainer
AnimatedContainer(
  duration: _animationDuration,
  // Valor finit específic, no null
  height: containerModel.isExpanded ? 300.0 : 0.0,
  // ...
)

// ❌ INCORRECTE - Alçada null
AnimatedContainer(
  duration: _animationDuration,
  // null no pot interpolar-se amb valors finits!
  height: containerModel.isExpanded ? null : 0.0,
  // ...
)
```

### Scroll Individual per Continguts Expandibles
Per contenidors plegables amb contingut potencialment gran, afegir un SingleChildScrollView:

```dart
// ✅ CORRECTE - Scroll individual per contingut
AnimatedContainer(
  duration: _animationDuration,
  height: containerModel.isExpanded ? maxExpandedHeight : 0.0,
  child: ClipRect(
    child: SingleChildScrollView(
      // Permet scroll dins del contenidor
      child: contentChild,
    ),
  ),
)
```

### Preservació i Restauració de Focus
En components amb animacions, implementar mecanismes per preservar i restaurar el focus:

```dart
// ✅ CORRECTE - Preservació i restauració de focus
// En el mètode que controla l'expansió
void setExpanded(bool expanded) {
  // Desar l'estat del focus actual
  final currentFocus = FocusManager.instance.primaryFocus;
  if (currentFocus != null) {
    _lastFocusedNode = currentFocus as FocusNode?;
  }
  
  // Canviar l'estat d'expansió
  (model as LdFoldableContainerModel).isExpanded = expanded;
  
  // Si estem expandint, restaurar focus després d'un retard
  if (expanded && _lastFocusedNode != null) {
    Future.delayed(_animationDuration, () {
      if (mounted && _lastFocusedNode != null) {
        _lastFocusedNode!.requestFocus();
      }
    });
  }
}
```

### Auto-Recuperació de Models
Implementar mecanismes de recuperació automàtica per a models perduts:

```dart
// ✅ CORRECTE - Recuperació automàtica de models
@override
Widget buildContent(BuildContext context) {
  // Verificar si el model existeix
  if (model == null) {
    // Intentar reparar
    _createBackupModel();
    
    // Mostrar widget temporal
    return Container(
      height: 50,
      width: double.infinity,
      child: Center(child: Text("Recuperant contingut...")),
    );
  }
  
  // Continuar amb el model verificat
  // ...
}

// Mètode auxiliar per crear un model de recanvi
void _createBackupModel() {
  if (model == null && mounted) {
    // Crear model amb configuració mínima
    model = LdFoldableContainerModel.fromMap({
      cfTag: tag,
      mfIsExpanded: widget.config[mfIsExpanded] as bool? ?? true,
      // Altres propietats essencials...
    });
    
    // Forçar reconstrucció
    setState(() {});
  }
}
```

---

*Aquest document serveix com a referència completa per mantenir la consistència d'estil en tot el projecte Sabina.*