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
  setField(pKey: mfText, pValue: label ?? '');
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
model.setField(pKey: mfTitle, pValue: 'Nou títol'); // Persisteix automàticament
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

## 🚨 Errors de Renderització i Scroll

### 1. No Cridar super.build() amb AutomaticKeepAliveClientMixin ⭐️
```dart
// ❌ ERROR GREU - Falta la crida a super.build()
@override
Widget build(BuildContext context) {
  // NO s'està cridant super.build(context)!
  return ListView(children: [...]);
}

// ✅ CORRECTE - Cridar super.build()
@override
Widget build(BuildContext context) {
  super.build(context); // Imprescindible!
  return ListView(children: [...]);
}
```

### 2. Implementació Incorrecta de wantKeepAlive
```dart
// ❌ ERROR - No implementar getter o retornar false
@override
bool get wantKeepAlive => false; // No preservarà estat

// ✅ CORRECTE - Retornar true per preservar estat
@override
bool get wantKeepAlive => true;
```

### 3. Renderització Ineficient en Scroll
```dart
// ❌ ERROR - Reconstruccions excessives
@override
Widget build(BuildContext context) {
  super.build(context);
  return SingleChildScrollView(
    child: Column(
      children: List.generate(100, (index) => ExpensiveWidget()),
    ),
  );
}

// ✅ CORRECTE - Utilitzar ListView.builder
@override
Widget build(BuildContext context) {
  super.build(context);
  return ListView.builder(
    itemCount: 100,
    itemBuilder: (context, index) => ExpensiveWidget(),
  );
}
```

### 4. No Utilitzar Keys en Llistes Dinàmiques
```dart
// ❌ ERROR - Llista sense keys
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// ✅ CORRECTE - Utilitzar keys per mantenir l'estat
ListView(
  children: items.map((item) => ItemWidget(
    key: ValueKey(item.id),
    item: item
  )).toList(),
)
```

### 5. Gestió Incorrecta de PageStorageKey
```dart
// ❌ ERROR - No utilitzar PageStorageKey en tabs o paged views
TabBarView(
  children: [
    MyListView(), // Perdrà la posició del scroll en canviar de tab
    OtherListView(),
  ],
)

// ✅ CORRECTE - Utilitzar PageStorageKey
TabBarView(
  children: [
    MyListView(key: PageStorageKey('myList')),
    OtherListView(key: PageStorageKey('otherList')),
  ],
)
```

## 🚨 Errors en Nous Models

### 1. Herència Incorrecta
```dart
// ❌ ERROR - Herència de classe obsoleta
class MeuModel extends LdWidgetModelAbs {
  // Implementació...
}

// ✅ CORRECTE - Herència directa de LdModelAbs
class MeuModel extends LdModelAbs {
  // Implementació...
}
```

### 2. Crides Incorrectes a setField
```dart
// ❌ ERROR - Crides sense noms de paràmetres
setField(cfLabel, 'Hola');

// ✅ CORRECTE - Crides amb noms de paràmetres
setField(pKey: cfLabel, pValue: 'Hola');
```

### 3. Ús de Cadenes Literals per a Traduccions
```dart
// ❌ ERROR - Cadena literal amb prefix ##
label: "##sWelcome"

// ✅ CORRECTE - Ús de constant importada
label: sWelcome
```

### 4. Implementació Incorrecta de notifyListeners
```dart
// ❌ ERROR - Cridar notifyListeners directament dins un mètode
void incrementCounter() {
  // Modificació i notificació barrejades
  counter++;
  notifyListeners();
}

// ✅ CORRECTE - Passar una funció a notifyListeners
void incrementCounter() {
  notifyListeners(() {
    counter++;
  });
}
```

### 5. No Gestionar Correctament els Observers
```dart
// ❌ ERROR - No deslligar observers
@override
void dispose() {
  // No es crida model?.detachObserver(this)
  super.dispose();
}

// ✅ CORRECTE - Deslligar observers correctament
@override
void dispose() {
  model?.detachObserver(this);
  super.dispose();
}
```

## 📝 Errors de Documentació

### 1. No Documentar README.md per Components
```
// ❌ ERROR - No crear un README.md per a cada component

// ✅ CORRECTE - Documentar components amb README.md
# LdButton

## Descripció
Widget de botó personalitzat amb suport per a traduccions.

## Ús Bàsic
```dart
LdButton(
  label: sAccept,
  onPressed: () => print('Acceptat'),
)
```
```

### 2. Comentaris Poc Clars o Absents
```dart
// ❌ ERROR - Comentaris insuficients
class ComplexComponent extends LdWidgetAbs {
  // Implementació sense explicació...
}

// ✅ CORRECTE - Comentaris adequats
/// Complex component that handles multiple states and animations.
/// 
/// This widget is designed to:
/// - Handle multiple rendering states
/// - Support transitions between states
/// - Persist state during navigation
class ComplexComponent extends LdWidgetAbs {
  // Implementació amb comentaris adequats...
}
```

*Document actualitzat per reflectir la nova arquitectura de models i prevenir errors comuns.*