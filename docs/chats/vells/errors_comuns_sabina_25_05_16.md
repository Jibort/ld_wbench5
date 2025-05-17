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

## 💻 Errors de Codi

### 4. Imports amb Paths Relatius
```dart
// ❌ ERROR RECURRENT
import '../../../utils/debug.dart';
import '../../core/ld_map.dart';

// ✅ CORRECTE - Sempre package complet
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/ld_map.dart';
```

### 5. Map vs LdMap en Signatures
```dart
// ❌ ERROR de tipus
static String tx(String key, Map<String, String>? namedArgs);
void updateData(Map<String, dynamic> data);

// ✅ CORRECTE - sempre LdMap
static String tx(String key, LdMap<String>? namedArgs);
void updateData(LdMap<dynamic> data);
```

### 6. Constructor Sense super()
```dart
// ❌ ERROR en constructors
LdButtonModel({required this.label}) : super();

// ✅ CORRECTE - amb paràmetres adequats
LdButtonModel.fromMap(LdMap<dynamic> pMap) : super.fromMap(pMap);
```

### 7. Interfícies Inline Incorrectes
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

### 8. HTML en Comentaris de Documentació
```dart
// ❌ ERROR - HTML directe
/// Exemple: LdMap<String>() causa problemes

// ✅ CORRECTE - HTML escapat
/// Exemple: LdMap&lt;String&gt;() funciona bé
```

### 9. Capçaleres de Fitxer Incompletes
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

## 🧹 Errors d'Organització

### 10. Imports Innecessaris
```dart
// ❌ ERROR - imports no utilitzats
import 'package:ld_wbench5/core/map_fields.dart'; // No s'usa
import 'package:ld_wbench5/models/user_model.dart'; // No s'usa

// ✅ CORRECTE - només imports necessaris
import 'package:ld_wbench5/utils/debug.dart';
```

### 11. No Actualitzar map_fields.dart
```dart
// ❌ ERROR - usar constants no definides
map[cfButtonType] = buttonType; // Constant no existeix!

// ✅ CORRECTE - primer afegir la constant
// A map_fields.dart:
const String cfButtonType = 'cf_button_type';
// Després usar-la:
map[cfButtonType] = buttonType;
```

### 12. Accessors Redundants
```dart
// ❌ ERROR - duplicar funcionalitat existent
LdButtonModel? get model => ctrl?.model as LdButtonModel?; // Ja al pare!

// ✅ CORRECTE - accessor específic
LdButtonModel? get buttonModel => model as LdButtonModel?;
```

## 🔄 Errors de Traducció

### 13. No Aplicar Traduccions en Botons
```dart
// ❌ ERROR - mostrar clau en lloc de traducció
Text(L.sChangeTheme) // Mostra ##sChangeTheme

// ✅ CORRECTE - aplicar .tx
Text(L.sChangeTheme.tx) // Mostra "Canviar Tema"
```

### 14. Conversions Innecessàries Map→LdMap
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

## 📋 Checklist Per Evitar Errors

### Abans d'entregar codi, verifica:
- [ ] **Constants**: cf/mf/ef correctes segons funcionalitat
- [ ] **Imports**: sempre package complet
- [ ] **Tipus**: LdMap enlloc de Map  
- [ ] **LdLabels reactius**: function observers dedicats
- [ ] **Constructors**: super() amb paràmetres adequats
- [ ] **Capçaleres**: completes amb camí, descripció, dates
- [ ] **Seccions**: organitzades fins columna 60
- [ ] **Documentació**: HTML escapat en comentaris
- [ ] **Imports**: només els necessaris
- [ ] **Constants**: definides a map_fields.dart abans d'usar
- [ ] **Traduccions**: .tx aplicat on cal

## 👤 Errors Específics de JIQ

### 15. Oblidar Revisar Traduccions de Botons
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

### 16. Configuració Inicial Incorrecta de LdLabels
**Símptoma**: Arguments d'interpolació no s'actualitzen amb canvis del model
```dart
// PATRÓ PROBLEMÀTIC detectat
labCounter = LdLabel(
  pPosArgs: [pageModel.counter.toString()], // Arguments "congelats"
);
model!.attachObserver(labCounter!); // Connexió directa problemàtica
```

### 17. Tendència a Modificar Directament els Models
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

### 18. Definició Inconsistent de Constants
**Símptoma**: Utilitzar noms de constants abans de definir-les a map_fields.dart
```dart
// ERROR recurrent
map[cfButtonType] = buttonType; // Constant no definida encara

// SOLUCIÓ
// Primer afegir a map_fields.dart, després usar
```

##### 🔧 Errors de Disseny de Serveis

### 19. Duplicitat de Serveis
**Símptoma**: Múltiples serveis amb funcionalitats similars

**Exemple**:
```dart
// ❌ ERROR: Múltiples serveis de tema
class LdTheme { ... }
class ThemeService { ... }

✅ CORRECCIÓ:
- Consolidar en un únic servei
- Mantenir la interfície pública
- Eliminar serveis redundants
- Actualitzar totes les references

---

## ⚠️ Notes Importants

### Per a Claude:
- **Comentaris `//JIQ>CLA:`**: Llegir, entendre, aplicar i eliminar automàticament després de processar
- **Vigilar especialment** els errors marcats com "específics de JIQ" per anticipar problemes
- **Revisar traduccions** sempre abans d'entregar codi amb botons o etiquetes
- **Verificar function observers** en tots els LdLabels que mostrin dades dinàmiques

### Per a JIQ:
- **Doble-check traduccions** després d'implementar nous widgets amb text
- **Recordar el patró d'function observers** per LdLabels reactius
- **Definir constants a map_fields.dart** abans d'usar-les en el codi

## 📋 Errors de Codificació
### 21. Variables No Utilitzades
Símptoma: Declaració de variables de classe que mai s'usen
dart// ❌ ERROR
class MeuServei {
  ThemeMode _themeMode;  // Mai s'usa
  String _currentThemeName;  // Mai s'usa
}
✅ CORRECCIÓ:
- Eliminar variables no referenciades
- Si cal mantenir-les, assegurar que s'usen
- Implementar mètodes getter/setter que les manipulin

### 22. Mètodes i Propietats No Implementats
Símptoma: Referència a mètodes o propietats que no existeixen
dart// ❌ ERROR
class ServeiTemes {
  // No definits, però referenciats
  ThemeData get darkTheme => ...
  ThemeData get lightTheme => ...
  void _notifyThemeChanged() => ...
}
✅ CORRECCIÓ:
- Implementar completament tots els mètodes referenciats
- Assegurar que tots els getters retornin valors
- Documentar qualsevol mètode complex

### 23. Ús de Paràmetres Deprecats en Flutter
Símptoma: Usar paràmetres de ColorScheme obsolets
dart// ❌ ERROR
ColorScheme(
  onBackground: colors.text,  // Deprecat
  background: colors.background,  // Poc recomanat
)
✅ CORRECCIÓ:
- Substituir onBackground per onSurface
- Usar surface en comptes de background
- Seguir la guia de migració de Flutter per ColorScheme

---

*Aquest document es revisa i actualitza constantment amb nous errors descoberts durant el desenvolupament.*