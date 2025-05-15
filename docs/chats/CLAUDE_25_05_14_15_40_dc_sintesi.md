# Síntesi Detallada del Projecte Sabina - Converses Recents

**Data:** 14 de maig de 2025  
**Projecte:** Sabina (ld_wbench5) - Flutter Framework

## 📋 Context General del Projecte

### Arquitectura Implementada
- **Framework:** Flutter amb patró MVC customitzat (Three-Layer)
- **Gestió d'estat:** Sense dependencies externes (NO GetX, NO Provider)
- **Sistema de traduccions:** Claus prefixades amb "##", gestió via StringTx.tx()
- **Mapes:** Ús de `LdMap<T>` en lloc de `Map<String, T>` arreu del projecte

### Arquitectura Three-Layer
1. **Widget Layer:** Només configuració, delega al controller
2. **Controller Layer:** Gestiona lògica, events i crea models
3. **Model Layer:** Estat persistent amb pattern Observer

## 🎯 Problema Principal Tractat

### Error de Traduccions
**Símptoma:** Botons mostraven `##sChangeTheme` i `##sChangeLanguage` en lloc del text traduït

### Anàlisi del Problema
```dart
// L.sChangeTheme retorna "##sChangeTheme" ✓
// LdButton rep aquest valor com cfLabel ✓  
// PERÒ LdButtonCtrl NO aplicava StringTx.applyTranslation() ✗
```

### Solució Implementada
Actualització completa de `LdButtonCtrl` amb:

1. **Constructor corregit:**
```dart
LdButtonCtrl(Map<String, dynamic> config) : super(config);
```

2. **Traducció automàtica en getter label:**
```dart
String get label {
  final labelText = config[cfLabel] as String? ?? "";
  if (labelText.isEmpty) return labelText;
  
  // Apply translation if needed
  return StringTx.applyTranslation(labelText);
}
```

3. **Mètodes abstractes implementats:**
   - `buildContent()`: Renderitza el botó amb Text() traduït
   - `onEvent()`: Gestiona esdeveniments  
   - `update()`: Actualitza aspectes específics

## 📚 Normes d'Estil Descobertes i Enforçades

### 1. Sistema de Constants (cf/mf/ef)
- **cf:** Configuration Fields - Camps UI (cfLabel, cfIsEnabled, cfButtonType)
- **mf:** Model Fields - Camps de dades del negoci
- **ef:** Event Fields - Camps d'events

### 2. Imports amb Package Complet
**✅ USAR:**
```dart
import 'package:ld_wbench5/utils/debug.dart';
```
**❌ EVITAR:**
```dart
import '../../../utils/debug.dart';
```

### 3. Convencions de Nomenclatura
```dart
// Classes amb comentaris descriptius ///
/// Model per al widget LdButton
class LdButtonModel 
extends LdWidgetModelAbs<LdButton> {
```

### 4. Alineació de Classes
```dart
class   LdButtonModel 
extends LdWidgetModelAbs {  // Primera lletra alineada
```

## 🏗 Evolució de l'Arquitectura Model-Controller

### Sistema d'Interpolació de Traduccions
**Descobert:** El sistema suporta tres tipus de paràmetres simultàniament:

1. **Paràmetres Posicionals:** `{0}`, `{1}`, etc.
2. **Paràmetres Nomenats:** `{name}`, `{count}`, etc.  
3. **Variables Automàtiques:** `{current_date}`, `{user_name}`, etc.

### Actualitzacions Implementades

**StringTx.tx() ampliada:**
```dart
static String tx(String key, [List<String>? positionalArgs, LdMap<String>? namedArgs]) {
  // 1. Paràmetres posicionals
  // 2. Paràmetres nomenats  
  // 3. Variables automàtiques
}
```

**Extensions de String:**
```dart
extension StringExtensions on String {
  String get tx => StringTx.tx(this);
  String txWith(List<String> positionalArgs);
  String txArgs(LdMap<String> namedArgs);
  String txFull(List<String> positionalArgs, LdMap<String> namedArgs);
}
```

**GlobalVariablesService creat:**
- Variables automàtiques: `{current_date}`, `{platform}`, `{app_version}`
- Suport per variables custom

## 🔧 Models Actualitzats

### LdButtonModel i LdLabelModel
Ambdós models ara inclouen:

1. **Propietats amb notificació de canvis**
2. **Suport per paràmetres de traducció:**
   - `positionalArgs: List<String>?`
   - `namedArgs: LdMap<String>?`
3. **Getter translatedLabel/translatedText** que aplica automàticament traduccions
4. **Constructor correcte:** `fromMap(LdMap<dynamic> pMap)`

## 📁 Fitxers Actualitzats

### Codi Base
- `string_tx.dart`: Sistema complet d'interpolació 
- `string_extensions.dart`: Extensions per facilitar ús
- `global_variables_service.dart`: **NOU** - Gestió variables automàtiques
- `L.dart`: Facade actualitzat amb nous mètodes

### Widgets
- `ld_button_model.dart`: **ACTUALITZAT** amb suport traduccions
- `ld_label_model.dart`: **ACTUALITZAT** amb RichText i traduccions
- `ld_button_ctrl.dart`: **FIXAT** problema traduccions

## 🎨 Millores Pendents Identificades

### Problemes Visuals (de les imatges)
1. **Estat visual del tema:** Inconsistència en selecció del tema "Sabina"
2. **Mode de tema:** Visualització inconsistent opcions (Sistema/Clar/Fosc)
3. **Layout general:** Possibles millores d'organització

### Problemes Tècnics
1. **RichText en LdLabel:** Implementació parcial per format (**bold**, *italic*, etc.)
2. **Tests de traduccions:** Validar funcionament paràmetres combinats

## ❌ Errors Comuns Comesos (A Evitar)

### 1. Sistema de Constants cf/mf/ef
**ERROR:** Usar `mfLabel` per camps UI
```dart
// ❌ INCORRECTE
map[mfLabel] = _label;  // mf és per dades del negoci

// ✅ CORRECTE  
map[cfLabel] = _label;  // cf és per configuració UI
```

### 2. Imports Amb Paths Relatius
**ERROR:** Usar paths relatius en lloc del package complet
```dart
// ❌ INCORRECTE
import '../../../utils/debug.dart';

// ✅ CORRECTE
import 'package:ld_wbench5/utils/debug.dart';
```

### 3. Ús de Map en lloc de LdMap
**ERROR:** Usar `Map<String, T>` en signatures
```dart
// ❌ INCORRECTE
static String tx(String key, Map<String, String>? namedArgs);

// ✅ CORRECTE
static String tx(String key, LdMap<String>? namedArgs);
```

### 4. Imports Innecessaris
**ERROR:** Importar fitxers que no es fan servir
```dart
// ❌ INCORRECTE (no usa LdMap directament)
import 'package:ld_wbench5/core/map_fields.dart';

// ✅ CORRECTE  
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
```

### 5. HTML en Comentaris de Docstrings
**ERROR:** Usar `<T>` directament en comentaris
```dart
// ❌ INCORRECTE
/// Exemple: LdMap<String>()

// ✅ CORRECTE
/// Exemple: LdMap&lt;String&gt;()
```

### 6. Constructor Sense Paràmetres del Pare
**ERROR:** No passar paràmetres al constructor pare
```dart
// ❌ INCORRECTE
LdButtonModel({required this.label}) : super();

// ✅ CORRECTE
LdButtonModel.fromMap(LdMap<dynamic> pMap) : super.fromMap(pMap);
```

### 7. Mètodes No Requerits
**ERROR:** Crear accessors quan ja existeixen al pare
```dart
// ❌ INCORRECTE (duplica funcionalitat de LdWidgetAbs)
LdButtonModel? get model => ctrl?.model as LdButtonModel?;

// ✅ CORRECTE
LdButtonModel? get buttonModel => model as LdButtonModel?;
```

### 8. Conversions Innecessàries
**ERROR:** Convertir Map a LdMap quan no cal
```dart
// ❌ INCORRECTE (pèrdua de recursos)
String txFromMap(Map<String, String> args) {
  final ldMap = LdMap<String>();
  args.forEach((key, value) => ldMap[key] = value);
  return StringTx.tx(this, null, ldMap);
}

// ✅ CORRECTE (usar LdMap directament)
String txArgs(LdMap<String> namedArgs);
```

### 9. Extensions Sense Comentaris de Classe
**ERROR:** No posar comentaris descriptius amb `///`
```dart
// ❌ INCORRECTE
class LdButtonModel extends LdWidgetModelAbs {

// ✅ CORRECTE
/// Model per al widget LdButton
class LdButtonModel extends LdWidgetModelAbs {
```

### 10. No Recordar Actualitzar map_fields.dart
**ERROR:** Usar constants que no existeixen
```dart
// ❌ ERROR
map[cfButtonType] = ... // Constant no definida

// ✅ CORRECTE
// Primer afegir a map_fields.dart:
const String cfButtonType = 'cf_button_type';
```

## 🚀 Estat Actual i Pròxims Passos

### ✅ Completat
- Sistema de traduccions completament refactoritzat
- Suport per interpolació múltiple (posicional + nomenat + automàtic)
- LdButtonCtrl fixat per traduccions
- Normes d'estil clarificades

### 🔄 Prioritat Alta
1. Verificar fix traduccions en LdButton
2. Aplicar mateix fix a LdLabel, LdTextField, etc.
3. Resoldre problemes visuals de selecció de tema

### 📝 Notes Importants
- El projecte està molt més avançat del que indicaven síntesis anteriors
- Tots els widgets principals ja estan refactoritzats
- L'arquitectura three-layer està ben implementada
- El sistema de traduccions és robust i extensible

Aquesta síntesi proporciona una base sólida per continuar el treball, especialment per resoldre els problemes visuals pendents i completar la implementació del RichText en LdLabel.