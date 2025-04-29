# Sabina App - Evolució d'Arquitectura

Aquest repositori conté la migració progressiva de l'arquitectura original de l'App Sabina a una nova arquitectura simplificada.

## Estratègia de Migració

S'ha implementat una estratègia de migració per passos:

1. **Preservació del codi original**: El codi original s'ha mantingut dins de `lib/lib_old/`
2. **Nova estructura simplificada**: S'ha creat una nova estructura de directoris a `lib/`
3. **Migració progressiva**: Es poden migrar components individualment mentre es manté l'aplicació funcional

## Nova Estructura de Directoris

```
lib/
├── lib_old/         # Codi original
├── core/            # Abstraccions i utilitats base 
├── services/        # Serveis centralitzats (tema, idioma, etc.)
├── ui/              # Components d'interfície d'usuari
│   ├── widgets/     # Widgets reutilitzables
│   └── pages/       # Pàgines de l'aplicació
├── utils/           # Eines i utilitats
└── main.dart        # Punt d'entrada de l'aplicació
```

## Millores en la Nova Arquitectura

La nova arquitectura soluciona els problemes identificats en l'arquitectura original:

1. **Jerarquia simplificada**: Menys nivells d'abstracció
2. **Menys codi boilerplate**: API més simple i intuïtiva
3. **Menor acoblament**: Components més independents
4. **Millor debugabilitat**: Ús extensiu de logs i tags
5. **Codi més mantenible**: Menys redundància i cicles de vida més clars

## Com Utilitzar Aquesta Arquitectura

### 1. Crear una Nova Pàgina

```dart
// model.dart
class MyPageModel extends SabinaModel {
  String _title = 'Títol Inicial';
  
  String get title => _title;
  set title(String value) {
    notifyListeners(() => _title = value);
  }
}

// page.dart
class MyPage extends SabinaPage {
  MyPage({Key? key}) : super(key: key, controller: MyPageController());
}

class MyPageController extends SabinaPageController<MyPage> {
  late final MyPageModel model;
  
  @override
  void initialize() {
    model = MyPageModel();
    model.attachController(this);
  }
  
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model.title)),
      body: Center(child: Text('Contingut de la pàgina')),
    );
  }
}
```

### 2. Crear un Nou Widget

```dart
class MyWidget extends SabinaWidget {
  MyWidget({Key? key}) : super(key: key, controller: MyWidgetController());
}

class MyWidgetController extends SabinaWidgetController<MyWidget> {
  @override
  void initialize() {
    // Inicialitzar widget
  }
  
  @override
  Widget buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('El meu widget'),
    );
  }
}
```

### 3. Emetre i Escoltar Events

```dart
// Emetre un event
EventBus().emit(SabinaEvent(
  type: EventType.custom,
  sourceTag: 'emissor_tag',
  targetTags: ['receptor_tag'],
  data: {'key': 'valor'},
));

// Escoltar events (a un controller)
@override
void onEvent(SabinaEvent event) {
  if (event.type == EventType.custom) {
    final valor = event.data['key'];
    // Fer alguna cosa amb el valor
  }
}
```

### 4. Traduir Textos

```dart
// Definir una nova clau a LocalizationService
static const String myKey = "myKey";

// Afegir traduccions als diccionaris a localization_service.dart
_dictionaries['ca'][myKey] = "El meu text en català";
_dictionaries['es'][myKey] = "Mi texto en español";
_dictionaries['en'][myKey] = "My text in English";

// Utilitzar la traducció
Text(LocalizationService.myKey.tx)
```

### 5. Utilitzar el Sistema de Debug

```dart
// Registrar un missatge informatiu
Debug.info("Informació important");

// Registrar un avís
Debug.warn("Cal tenir en compte això");

// Registrar un error
Debug.error("S'ha produït un error", Exception("Detalls de l'error"));

// Registrar un missatge de debug específic
Debug.debug(DebugLevel.debug_1, "Informació detallada de debug");
```

## Migració des del Codi Original

Per migrar components des del codi original:

1. Identificar el component a migrar (vista, widget, model)
2. Crear les noves classes utilitzant l'arquitectura simplificada
3. Adaptar la funcionalitat mantenint la mateixa API pública si és possible
4. Modificar les referències al component per utilitzar la nova implementació
5. Provar el component migrat
6. Una vegada tot funciona correctament, eliminar el component original

## Patrons de Disseny Utilitzats

- **Singleton**: Per serveis i gestor d'events
- **MVC**: Separació de Model-Vista-Controlador
- **Observer**: Sistema d'events i subscripcions
- **Dependency Injection**: Controladors, models i vistes
- **Mixin**: Per a funcionalitats compartides com tagging

## Suggeriments per a Evolució Futura

- Considerar la migració a un gestor d'estat més avançat com Riverpod o Bloc
- Implementar una capa de repositoris per a la gestió de dades
- Afegir tests unitaris i d'integració
- Considerar l'ús d'injection de dependències més formal