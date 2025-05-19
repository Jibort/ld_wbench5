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
// MEMBRES ESTÀTICS =====================================
// GETTERS/SETTERS ESTÀTICS =============================
// MEMBRES ==============================================
// CONSTRUCTORS/DESTRUCTORS =============================
// GETTERS/SETTERS ======================================
// IMPLEMENTACIÓ 'Interface' ============================
// FUNCIONALITAT =============================
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

## Nova Secció: Models i Estructura de Dades

### Arquitectura de Models

#### LdModelAbs: Classe Base per a Models
- **Herència**: Tots els models han d'estendre directament de `LdModelAbs`
- **Ús de LdTaggableMixin**: Incorporat per defecte

```dart
// Exemple d'implementació de model
class ExempleModel extends LdModelAbs {
  // Constructor amb paràmetres semàntics
  ExempleModel({
    String? pTag,
    required String title,
    int counter = 0,
  }) : super(pTag: pTag) {
    // Ús de setField per inicialitzar
    setField(mfTitle, title);
    setField(mfCounter, counter);
  }

  // Getters semàntics
  String get title => getField(mfTitle) ?? '';
  int get counter => getField(mfCounter) ?? 0;
}
```

#### Regles per a Construcció de Models
1. **Constructors**
   - Sempre proporcionar constructors semàntics
   - Usar `setField()` per inicialitzar valors
   - Proporcionar valors per defecte quan sigui possible

2. **Getters i Setters**
   - Crear getters i setters semàntics
   - Usar `getField()` i `setField()` internament
   - Proporcionar valors per defecte

3. **Generació de Tags**
   - Usar `generateTag()` per defecte
   - Possibilitat de sobreescriure per casos específics

### Persistència

#### Ús de StatePersistenceService
- Tots els models usen `StatePersistenceService` per persistència
- Persistència automàtica en cada modificació
- Recuperació de models via tag únic

```dart
// Exemple de recuperació de model
final model = ModelExample.fromPersistence(tag) ?? ModelExample();
```

[Resta del document original: Patró Específic per LdLabels Reactius, Sistema de Traduccions, Comentaris de Comunicació Interna, Procés de Revisió de Codi, etc.]

*Document actualitzat per reflectir la nova arquitectura de models en el projecte Sabina.*
