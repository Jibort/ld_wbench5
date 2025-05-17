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
import '../../core/ld_map.dart';

// ✅ CORRECTE - Sempre package complet
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/ld_map.dart';
```

### 6. Map vs LdMap en Signatures
```dart
// ❌ ERROR de tipus
static String tx(String key, Map<String, String>? namedArgs);
void updateData(Map<String, dynamic> data);

// ✅ CORRECTE - sempre LdMap
static String tx(String key, LdMap<String>? namedArgs);
void updateData(LdMap<dynamic> data);
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
import 'package:ld_wbench5/models/user_model.dart'; // No s'usa

// ✅ CORRECTE - només imports necessaris
import 'package:ld_wbench5/utils/debug.dart';
```

### 13. No Actualitzar map_fields.dart
```dart
// ❌ ERROR - usar constants no definides
map[cfButtonType] = buttonType; // Constant no existeix!

// ✅ CORRECTE - primer afegir la constant
// A map_fields.dart:
const String cfButtonType = 'cf_button_type';
// Després usar-la:
map[cfButtonType] = buttonType;
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

### 16. Conversions Innecessàries Map→LdMap
```dart
// ❌ ERROR - conversió costosa innecessària
String txFromMap(Map<String, String> args) {
  final ldMap = LdMap<String>();
  args.forEach((key, value) => ldMap[key] = value);
  return StringTx.tx(this, null, ldMap);
}

// ✅ CORRECTE - usar LdMap directament
String txArgs(LdMap<String> namedArgs) {
  return StringTx.tx(this, null, namedArgs);
}
```

## 📋 Errors de Codificació

### 17. Variables No Utilitzades
**Símptoma**: Declaració de variables de classe que mai s'usen
```dart
// ❌ ERROR
class MeuServei {
  ThemeMode _themeMode;  // Mai s'usa
  String _currentThemeName;  // Mai s'usa
}

// ✅ CORRECTE
class MeuServei {
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(ThemeMode.system);
  final ValueNotifier<String> _currentThemeNotifier = ValueNotifier('themeDexeusClear');
  
  // Getters/setters que realment usen aquestes variables
  ThemeMode get themeMode => _themeModeNotifier.value;
  set themeMode(ThemeMode pMode) { /* implementació */ }
}
```

### 18. Mètodes i Propietats No Implementats
**Símptoma**: Referència a mètodes o propietats que no existeixen
```dart
// ❌ ERROR
class ServeiTemes {
  // No definits, però referenciats
  ThemeData get darkTheme => ...
  ThemeData get lightTheme => ...
  void _notifyThemeChanged() => ...
}

// ✅ CORRECTE
class ServeiTemes {
  // Implementacions completes
  ThemeData get darkTheme {
    // Implementació robusta amb fallback
    final themeName = _currentThemeNotifier.value;
    return _darkThemes.containsKey(themeName) 
      ? _darkThemes[themeName]! 
      : _darkThemes[themeDexeusDark]!;
  }
  
  void _notifyThemeChanged() {
    // Notifica explícitament a tots els listeners
    _themeNotifier.notifyListeners();
  }
}
```

### 19. Ús de Paràmetres Deprecats en Flutter
**Símptoma**: Usar paràmetres de Flutter que han estat marcats com deprecats
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

### 20. Accés a Mapes Sense Verificació
**Símptoma**: Accessos a mapes sense comprovació prèvia d'existència
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

### 21. Reconstruccions Innecessàries amb WidgetsBinding.addPostFrameCallback
**Símptoma**: Ús incorrecte de `addPostFrameCallback` que causa loops de reconstrucció
```dart
// ❌ ERROR
@override
Widget buildPage(BuildContext context) {
  // Això s'executa a cada frame i pot causar reconstruccions infinites!
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _updateControllerReferences();
  });
  
  // ... resta del codi
}

// ✅ CORRECTE
@override
void initState() {
  super.initState();
  
  // Programar una única actualització després del primer frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _updateControllerReferences();
  });
}

// Alternativament, amb bandera estàtica
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

## 🔧 Errors de Disseny de Serveis

### 22. Duplicitat de Serveis
**Símptoma**: Múltiples serveis amb funcionalitats similars

**Exemple**:
```dart
// ❌ ERROR: Múltiples serveis de tema
class LdTheme { ... }
class ThemeService { ... }
```

**✅ CORRECCIÓ**:
- Consolidar en un únic servei
- Mantenir la interfície pública
- Eliminar serveis redundants
- Actualitzar totes les referencias

### 23. Implementació Incorrecta de Singleton
**Símptoma**: Implementació parcial o incorrecta del patró singleton
```dart
// ❌ ERROR
class ServeiTemes {
  // Falta instància, constructor privat o getter
  static ServeiTemes get s => _inst;  // Però _inst no està definit!
}

// ✅ CORRECTE
class ServeiTemes {
  // Singleton complet
  static final ServeiTemes _inst = ServeiTemes._();
  static ServeiTemes get s => _inst;
  
  // Constructor privat
  ServeiTemes._();
}
```

### 24. No Dessubscripció d'Observers en dispose()
**Símptoma**: Memory leaks o errors en cancel·lar pantalla
```dart
// ❌ ERROR
@override
void dispose() {
  super.dispose();
  // Falta dessubscripció d'observers!
}

// ✅ CORRECTE
@override
void dispose() {
  // Desconnectar tots els observers
  model?.detachObserverFunction(_obsCount);
  model?.detachObserverFunction(_obsTime);
  super.dispose();
}
```

## 👤 Errors Específics de JIQ

### 25. Oblidar Revisar Traduccions de Botons
**Símptoma**: Els botons mostren ##clau en lloc del text traduït
```dart
// ERROR observat en LdButtonCtrl
return ElevatedButton(
  child: Text(label), // Mostra "##sChangeTheme"
};

// CORRECCIÓ aplicada
return ElevatedButton(
  child: Text(label.tx), // Mostra "Canviar Tema"
};
```

### 26. Configuració Inicial Incorrecta de LdLabels
**Símptoma**: Arguments d'interpolació no s'actualitzen amb canvis del model
```dart
// PATRÓ PROBLEMÀTIC detectat
labCounter = LdLabel(
  pPosArgs: [pageModel.counter.toString()], // Arguments "congelats"
);
model!.attachObserver(labCounter!); // Connexió directa problemàtica
```

### 27. Tendència a Modificar Directament els Models
**Símptoma**: Manipulació manual dels LdLabel en lloc d'usar function observers
```dart
// PATRÓ observat ocasionalment
@override
void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
  setState(() {
    // Modificació directa del model del widget
    (labTime?.model as LdLabelModel).label = newValue;
  });
}
```

### 28. Definició Inconsistent de Constants
**Símptoma**: Utilitzar noms de constants abans de definir-les a map_fields.dart
```dart
// ERROR recurrent
map[cfButtonType] = buttonType; // Constant no definida encara

// SOLUCIÓ
// Primer afegir a map_fields.dart, després usar
```

## 🚀 Errors de Rendiment

### 29. Ús Incorrecte de setState() per Actualitzacions Freqüents
**Símptoma**: Tota la UI es reconstrueix cada vegada que es crida setState(), fins i tot si els canvis són mínims
```dart
// ❌ ERROR - Reconstrucció excessiva
_obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == TimeService.s.model && mounted) {
    final time = TimeService.s.model.formattedTime;
    setState(() { // Reconstrueix TOT el widget pare!
      labTime!.setTranslationArgs(positionalArgs: [time]);
    });
  }
};

// ✅ CORRECTE - Reconstrucció localitzada
_obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == TimeService.s.model && mounted) {
    final time = TimeService.s.model.formattedTime;
    // Delega la reconstrucció al widget específic
    labTime!.setTranslationArgsIsolated(positionalArgs: [time]);
  }
};
```

### 30. addPostFrameCallback dins de build()
**Símptoma**: El mètode build es crida repetidament degut a un callback que pot provocar setState()
```dart
// ❌ ERROR - Cicle infinit de reconstrucció
@override
Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Si aquesta línia conté o pot desencadenar un setState()...
    _updateControllerReferences();
    // ...provocarà una nova crida a build() després d'un frame
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

---

## ⚠️ Notes Importants

### Per a Claude:
- **Comentaris `//JIQ>CLA:`**: Llegir, entendre, aplicar i eliminar automàticament després de processar
- **Vigilar especialment** els errors marcats com "específics de JIQ" per anticipar problemes
- **Revisar traduccions** sempre abans d'entregar codi amb botons o etiquetes
- **Verificar function observers** en tots els LdLabels que mostrin dades dinàmiques
- **Aïllar actualitzacions freqüents** usant setTranslationArgsIsolated per components que s'actualitzen sovint

### Per a JIQ:
- **Doble-check traduccions** després d'implementar nous widgets amb text
- **Recordar el patró d'function observers** per LdLabels reactius
- **Definir constants a map_fields.dart** abans d'usar-les en el codi
- **Implementar setTranslationArgsIsolated** a LdLabel per optimitzar rendiment

*Aquest document es revisa i actualitza constantment amb nous errors descoberts durant el desenvolupament.*