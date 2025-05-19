# Errors Comuns del Projecte Sabina
## Guia per prevenir errors recurrents

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

[Tots els errors arquitecturals, de codi, documentació, organització, traducció, codificació, disseny de serveis, rendiment i animacions del document original]

## 🚨 Nous Errors en Models

### 1. Accés Directe a Mapes
```dart
// ❌ ERROR - Accés directe al mapa
final title = model._dataMap['title']; // Incorrecte!

// ✅ CORRECTE - Ús de getField()
final title = model.getField(mfTitle); // Correcte
```

### 2. Inicialització Incorrecta de Models
```dart
// ❌ ERROR - Constructor sense ús de setField
LdTextFieldModel({required this.label}) : super(); // Incorrecte

// ✅ CORRECTE - Ús de setField
LdTextFieldModel({String? label}) : super() {
  setField(mfText, label ?? '');
}
```

### 3. No Proporcionar Valors per Defecte
```dart
// ❌ ERROR - Sense valors per defecte
String get title => getField(mfTitle); // Pot retornar null

// ✅ CORRECTE - Amb valors per defecte
String get title => getField(mfTitle) ?? 'Títol per defecte';
```

### 4. Modificació Sense Persistència
```dart
// ❌ ERROR - Modificació sense persistir
model._dataMap['title'] = 'Nou títol'; // No persisteix

// ✅ CORRECTE - Ús de setField
model.setField(mfTitle, 'Nou títol'); // Persisteix automàticament
```

### 5. Generació Inadequada de Tags
```dart
// ❌ ERROR - Tag no únic
class MyModel extends LdModelAbs {
  MyModel() {
    tag = 'my_model'; // Tag estàtic
  }
}

// ✅ CORRECTE - Ús de generació automàtica
class MyModel extends LdModelAbs {
  MyModel({String? pTag}) : super(pTag: pTag);
  // Usa generateTag() per defecte
}
```

### 6. No Recuperar Models Correctament
```dart
// ❌ ERROR - Recuperació sense fallback
final model = TestModel.fromPersistence(tag); // Pot ser null

// ✅ CORRECTE - Amb fallback
final model = TestModel.fromPersistence(tag) ?? TestModel();
```

### 7. Barreja de Constructors
```dart
// ❌ ERROR - Constructor inconsistent
LdTextFieldModel.fromMap(MapDyns map); // No cridat correctament

// ✅ CORRECTE - Constructor consistent
factory LdTextFieldModel.fromMap(MapDyns map) {
  return LdTextFieldModel(
    pTag: map[cfTag],
    initialText: map[mfText],
  );
}
```

## 💻 Errors de Persistència

### 8. Accés Directe a StatePersistenceService
```dart
// ❌ ERROR - Accés directe al servei
final data = StatePersistenceService.s.getValue('key'); // Incorrecte

// ✅ CORRECTE - A través del model
final model = ModelExample.fromPersistence(tag);
```

### 9. No Gestionar Estat entre Reconstruccions
```dart
// ❌ ERROR - Pèrdua d'estat
void initialize() {
  model = TestModel(); // Sempre nou, sense recuperar
}

// ✅ CORRECTE - Recuperació d'estat
void initialize() {
  model = TestModel.fromPersistence(tag) ?? TestModel();
}
```

[Resta de seccions originals del document: Errors Específics de JIQ, Notes Importants, etc.]

*Document actualitzat per reflectir la nova arquitectura de models i prevenir errors comuns.*
