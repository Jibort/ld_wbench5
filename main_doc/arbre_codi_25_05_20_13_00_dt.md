# Estructura del Codi del Projecte Sabina

## Estructura de Directoris Principals
```
lib/
├── core/           # Components centrals i abstractes del framework
├── services/       # Serveis globals de l'aplicació
├── ui/             # Interfície d'usuari
│   ├── app/        # Configuració de l'aplicació
│   ├── pages/      # Pàgines de l'aplicació
│   └── widgets/    # Widgets personalitzats
├── utils/          # Utilitats i eines auxiliars
└── main.dart       # Punt d'entrada de l'aplicació
```

## Components Principals

### Core (Nucli del Framework)
1. **Arquitectura de Models i Controllers**
   - `core/ld_model_abs.dart`: Model base abstracte (`LdModelAbs`)
     - Dependències: `core/ld_taggable_mixin.dart`, `core/map_fields.dart`
     - Responsabilitat: Gestió d'estat base per a tots els models
     - **Actualització**: Ara tots els models hereten directament d'aquesta classe

   - `core/ld_page/ld_page_abs.dart`: Pàgina base abstracta (`LdPageAbs`)
     - Dependències: `core/ld_model_abs.dart`, `core/map_fields.dart`
     - Responsabilitat: Definició de pàgines amb gestió de configuració i cicle de vida

   - `core/ld_widget/ld_widget_abs.dart`: Widget base abstracte (`LdWidgetAbs`)
     - Dependències: `core/ld_model_abs.dart`, `core/map_fields.dart`
     - Responsabilitat: Base per a tots els widgets personalitzats

   - `core/ld_widget/ld_widget_ctrl_abs.dart`: Controlador base abstracte (`LdWidgetCtrlAbs`)
     - Dependències: `core/ld_model_abs.dart`, `core/ld_widget_abs.dart`
     - Responsabilitat: Definició del comportament dels controladors

2. **Classes Obsoletes (En procés de deprecació)**
   - `core/ld_widget/ld_widget_model_abs.dart`: Model base per a widgets (`LdWidgetModelAbs`)
   - `core/ld_page/ld_page_model_abs.dart`: Model base per a pàgines (`LdPageModelAbs`)

3. **Eines de Suport**
   - `core/extensions/`: Extensions per a tipus de dades
     - `color_extensions.dart`: Mètodes addicionals per a colors
     - `map_extensions.dart`: Mètodes per a manipulació de mapes
     - `string_extensions.dart`: Mètodes per a tractament de strings
     - `type_extensions.dart`: Mètodes per a manipulació de tipus

   - `core/event_bus/`: Sistema de gestió d'events
     - `event_bus.dart`: Bus d'events centralitzat
     - `ld_event.dart`: Definició d'events

   - `core/L10n/string_tx.dart`: Sistema de traducció de cadenes

### Serveis
1. **Serveis Globals**
   - `services/L.dart`: Servei de traduccions
   - `services/theme_service.dart`: Gestió de temes
   - `services/time_service.dart`: Servei de temps
   - `services/global_variables_service.dart`: Variables globals
   - `services/maps_service.dart`: Gestió de mapes de configuració
   - `services/state_persistance_service.dart`: Persistència d'estat

### UI (Interfície d'Usuari)
1. **Aplicació Principal**
   - `ui/app/sabina_app.dart`: Definició de l'aplicació Sabina
   - `ui/app/sabina_app_ctrl.dart`: Controlador de l'aplicació
   - `ui/app/sabina_app_model.dart`: Model de l'aplicació

2. **Pàgines**
   - `ui/pages/test_page/`: Pàgina de proves
     - `test_page.dart`
     - `test_page_ctrl.dart`
     - `test_page_model.dart`

   - `ui/pages/test_page2/`: Pàgina de proves 2
     - `test_page2.dart`
     - `test_page2_ctrl.dart`
     - `test_page2_model.dart`

3. **Widgets Personalitzats (Refactoritzats)**
   - `ui/widgets/ld_label/`: Etiqueta amb suport per traducció i interpolació (Nova implementació)
     - `ld_label.dart`: Widget principal
     - `ld_label_model.dart`: Model que hereta directament de LdModelAbs
     - `ld_label_ctrl.dart`: Controlador optimitzat
     - `README.md`: Documentació del component

   - `ui/widgets/`: Diversos widgets personalitzats
     - `ld_app_bar/`: Barra d'aplicació
     - `ld_button/`: Botó personalitzat
     - `ld_check_box/`: Checkbox personalitzat
     - `ld_foldable_container/`: Contenidor plegable
     - `ld_label/`: Etiqueta amb traducció
     - `ld_scaffold/`: Scaffold personalitzat
     - `ld_text_field/`: Camp de text personalitzat
     - `ld_theme_selector/`: Selector de temes
     - `ld_theme_viewer/`: Visualitzador de temes

### Utilitats
- `utils/`: Utilitats diverses
  - `debug.dart`: Sistema de registre de debug
  - `full_set.dart`: Contenidor que assegura modificabilitat
  - `once_set.dart`: Contenidor que permet inicialitzar una vegada
  - `str_full_set.dart`: Contenidor especialitzat per strings
  - `str_once_set.dart`: Variant de `once_set` per strings
  - `theme_utils.dart`: Utilitats per temes

### Punt d'Entrada
- `main.dart`: Inicialitza l'aplicació Sabina

## Principis Arquitectònics Clau
- Arquitectura MVC amb tres capes: Model, Controlador, Widget
- Ús de mixins i classes abstractes per modularitat
- Sistema de traducció basat en claus
- Gestió d'estat persistent
- Sistema d'events centralitzat
- Components reutilitzables i extensibles

## Patrons de Disseny
- Observer (per actualitzacions de model)
- Singleton (per serveis globals)
- Factory (per creació de components)
- Dependency Injection (implícit en l'arquitectura)

## Tecnologies i Llibreries
- Flutter
- Dart
- EventBus
- Internacionalització
- Gestió d'estat propi (sense dependencies externes)