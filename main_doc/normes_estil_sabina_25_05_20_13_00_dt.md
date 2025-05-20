# Normes d'Estil i Codificació - Projecte Sabina

## 1. Estructura de Fitxers i Capçaleres

### Format de Capçalera
```dart
// lib/ui/widgets/ld_button/ld_button.dart
// Widget de botó personalitzat amb suport per traduccions i estils temàtics
// Created: 2025/05/20 dl. JIQ
// Updated: 2025/05/21 dt. CLA - Afegida documentació de README
```

### Directoris i Nomenament
- `lib/ui/widgets/ld_component/` → Components UI reutilitzables
- `lib/ui/pages/page_name/` → Pàgines de l'aplicació
- `lib/services/` → Serveis globals
- `lib/core/` → Classes base i abstraccions
- `lib/utils/` → Utilitats i eines auxiliars

### Estructura de Component
```
lib/ui/widgets/ld_component/
├── ld_component.dart           # Widget principal
├── ld_component_model.dart     # Model de dades
├── ld_component_ctrl.dart      # Controlador
└── README.md                   # Documentació (OBLIGATORI)
```

## 2. Organització Interna de Codi

### Ordre d'Imports (blocs separats per línies en blanc)
```dart
// 1. Dart/Flutter
import 'package:flutter/material.dart';

// 2. Llibreries externes
import 'package:external_package/external.dart';

// 3. Projecte propi (alfabètic)
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/services/L.dart';
```

### Organització de Classes
```dart
class      TestPageCtrl 
extends    LdPageCtrlAbs<TestPage>
implements LdModelObserverIntf {

  // MEMBRES ESTÀTICS =====================================
  static const String TAG = 'TestPageCtrl';
  
  // MEMBRES ==============================================
  late final LdLabel? _labCounter;
  
  // CONSTRUCTORS ========================================
  TestPageCtrl(super.pWidget);
  
  // OVERRIDE MÈTODES ====================================
  @override
  void initialize() { ... }
  
  // FUNCIONS PÚBLIQUES =================================
  void handlePress() { ... }
  
  // FUNCIONS PRIVADES ==================================
  void _setupLabels() { ... }
}
```

## 3. Nomenclatura i Constants

### Sistema de Constants
- **cf**: Configuration Fields (UI)
  ```dart
  const String cfLabel = 'cf_label';
  const String cfIsEnabled = 'cf_is_enabled';
  ```
- **mf**: Model Fields (Dades de negoci)
  ```dart
  const String mfTitle = 'mf_title';
  const String mfCounter = 'mf_counter';
  ```
- **ef**: Event Fields (Events)
  ```dart
  const String efOnPressed = 'ef_on_pressed';
  ```

### Strings per Traduccions
```dart
// A services/L.dart
const String sWelcome = '##sWelcome';
const String sCancel = '##sCancel';
```

### Convencions de Noms
- **Classes**: PascalCase
  ```dart
  class LdButton { ... }
  ```
- **Variables i mètodes**: camelCase
  ```dart
  void handleButtonPress() { ... }
  final int userCounter = 0;
  ```
- **Constants**: camelCase (si són locals) o UPPER_SNAKE_CASE (si són estàtiques)
  ```dart
  const int maxRetries = 3; // local
  static const int MAX_RETRIES = 3; // estàtica
  ```
- **Fitxers**: snake_case
  ```
  ld_button.dart
  theme_service.dart
  ```

## 4. Paràmetres i Arguments

### Nomenclatura de Paràmetres
- **p...**: Paràmetres generals
  ```dart
  void setTitle(String pTitle) { ... }
  ```
- **pfn...**: Funcions callback
  ```dart
  void handleData(void Function(String) pfnCallback) { ... }
  ```

### Paràmetres amb Nom Obligatoris
```dart
// ✅ CORRECTE
setField(pKey: cfLabel, pValue: 'Hola');

// ❌ INCORRECTE
setField(cfLabel, 'Hola');
```

### Valors per Defecte en Models
```dart
// ✅ CORRECTE
String get title => getField(mfTitle) ?? '';

// ❌ INCORRECTE
String get title => getField(mfTitle); // Pot retornar null
```

## 5. Models i Controladors

### Models (Nova Arquitectura)
```dart
class ExampleModel extends LdModelAbs {
  // Constructor
  ExampleModel({
    String? pTag,
    String? title,
    int counter = 0,
  }) : super(pTag: pTag) {
    setField(pKey: mfTitle, pValue: title ?? '');
    setField(pKey: mfCounter, pValue: counter);
  }
  
  // Getters/Setters
  String get title => getField(mfTitle) ?? '';
  set title(String value) => setField(pKey: mfTitle, pValue: value);
  
  int get counter => getField(mfCounter) ?? 0;
  
  // Mètodes específics
  void incrementCounter() {
    notifyListeners(() {
      setField(pKey: mfCounter, pValue: counter + 1);
    });
  }
}
```

### Controladors
```dart
class ExampleCtrl extends LdWidgetCtrlAbs<ExampleWidget> {
  // Constructor
  ExampleCtrl(super.pWidget);
  
  @override
  void initialize() {
    model = ExampleModel.fromPersistence(tag) ?? 
            ExampleModel(pTag: tag);
    // ...
  }
  
  @override
  Widget buildContent(BuildContext context) {
    final exampleModel = model as ExampleModel?;
    if (exampleModel == null) return const SizedBox.shrink();
    
    return Column(
      children: [
        Text(exampleModel.title),
        // ...
      ],
    );
  }
}
```

### Function Observers
```dart
// ✅ CORRECTE - Observer dedicat
late final FnModelObs _obsCounter;

_obsCounter = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == model && mounted) {
    final count = model.counter.toString();
    if (labCounter != null) {
      pfnUpdate();
      labCounter!.setTranslationArgsIsolated(positionalArgs: [count]);
    }
  }
};

// Afegir l'observer
model!.attachObserverFunction(_obsCounter);
```

## 6. Widgets i Renderització

### Gestió d'Estats
```dart
class ExampleState extends State<Example> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // IMPORTANT!
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // OBLIGATORI amb AutomaticKeepAliveClientMixin
    
    // Resta del build...
  }
}
```

### Optimització de Llistes
```dart
// ✅ CORRECTE - ListView.builder
@override
Widget build(BuildContext context) {
  super.build(context);
  return ListView.builder(
    key: PageStorageKey('my_list'), // Per mantenir posició
    itemCount: items.length,
    itemBuilder: (context, index) => ItemWidget(
      key: ValueKey(items[index].id), // Per mantenir estat
      item: items[index],
    ),
  );
}
```

## 7. Traduccions i Internacionalització

### Ús de Constants
```dart
// ✅ CORRECTE - Ús de constants
LdLabel(
  label: sWelcome,
  positionalArgs: ["Usuari"],
);

// ❌ INCORRECTE - Cadenes literals
LdLabel(
  label: "##sWelcome",
  positionalArgs: ["Usuari"],
);
```

### Arguments d'Interpolació
```dart
// ✅ CORRECTE - Aïllar actualització per rendiment
_obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == TimeService.s.model && mounted) {
    final time = TimeService.s.formattedTime;
    labTime!.setTranslationArgsIsolated(positionalArgs: [time]);
  }
};
```

## 8. Tests i Documentació

### README.md (Obligatori)
```markdown
# LdComponent

## Descripció
Widget que implementa [funcionalitat específica]...

## Ús Bàsic
```dart
LdComponent(
  label: sComponentTitle,
  isEnabled: true,
  onPressed: () => print('Premut!'),
)
```

## Propietats
- `label`: Text principal (traduïble)
- `isEnabled`: Habilita/deshabilita interacció

## Millors Pràctiques
- Sempre connectar amb un function observer si mostrarà dades dinàmiques
- Proporcionar fallbacks per a tots els paràmetres opcionals
```

### Tests Unitaris
```dart
// test/widgets/ld_button_test.dart
testWidgets('LdButton mostra text correctament', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: LdButton(
        label: 'Test',
        onPressed: () {},
      ),
    ),
  ));
  
  expect(find.text('Test'), findsOneWidget);
});
```

## 9. Refactoritzacions i Migració de Codi

### Refactorització de Components
1. Reanomenar els components existents (p.ex. LdOldLabel)
2. Implementar noves versions amb la nova arquitectura
3. Actualitzar tests i documentació
4. Deprecar versions antigues
5. Migrar usos existents progressivament

### Mètode Recomanat de Migració
```dart
// Pas 1: Marcar classes antigues com a obsoletes
@Deprecated('Usar LdLabel en lloc seu')
class LdOldLabel extends LdWidgetAbs { ... }

// Pas 2: Implementar nova versió
class LdLabel extends LdWidgetAbs { ... }

// Pas 3: Proporcionar mètode de migració
extension LdLabelMigration on LdOldLabel {
  LdLabel toNewImplementation() {
    return LdLabel(
      label: this.label,
      // ...
    );
  }
}
```

## 10. Protocol de Revisió de Codi

### Checklist de Revisió
- [ ] El fitxer té la capçalera estàndard correcta
- [ ] Els imports estan organitzats en blocs adequats
- [ ] Els models estenen directament LdModelAbs
- [ ] setField s'utilitza amb paràmetres amb nom
- [ ] Tots els getters tenen valors per defecte
- [ ] No hi ha accés directe als mapes interns
- [ ] Els widgets reactius utilitzen function observers
- [ ] La documentació README.md està present i completa
- [ ] Els tests cobreixen els casos d'ús principals
- [ ] No hi ha codis comentats o TODOs sense explicació

### Comentaris de Revisió
Els comentaris de revisió han de ser:
- Específics: Referenciar línies exactes
- Constructius: Explicar per què i com millorar
- Documentats: Enllaçar a la documentació rellevant

```
Línia 45: Utilitzar setField amb paràmetres amb nom:
setField(pKey: cfLabel, pValue: value)
Veure normes d'estil secció 4.
```