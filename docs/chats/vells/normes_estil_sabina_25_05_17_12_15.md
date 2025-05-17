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
Alinear a la columna lliure més a la dreta:
```dart
class      TestPageCtrl 
extends    LdPageCtrlAbs<TestPage>
implements LdModelObserverIntf {
```

### Seccions de Codi
Agrupar lògicament amb capçaleres:
```dart
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
> **Qualsevol LdLabel que mostri dades que canvien SEMPRE necessita un function observer dedicat que actualitzi els arguments de traducció manualment via setTranslationArgs().**

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
        setState(() {
          {labelInstance}!.setTranslationArgs(positionalArgs: [{data}]);
        });
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

---

*Aquest document serveix com a referència completa per mantenir la consistència d'estil en tot el projecte Sabina.*