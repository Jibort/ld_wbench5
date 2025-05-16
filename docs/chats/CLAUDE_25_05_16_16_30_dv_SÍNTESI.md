Síntesi Completa del Projecte Sabina - Actualització 16 de Maig 2025
Data: 16 de maig de 2025 - 14:25
Projecte: Sabina (ld_wbench5) - Flutter Framework
Versió: 1.2.0
📋 Context General del Projecte
Objectiu del Projecte
Sabina és un framework Flutter personalitzat que implementa una arquitectura MVC de tres capes, amb un sistema avançat de traduccions i gestió d'estat sense dependencies externes.
Arquitectura Implementada

Framework: Flutter amb patró MVC customitzat (Three-Layer)
Gestió d'estat: Sense dependencies externes (NO GetX, NO Provider)
Sistema de traduccions: Claus prefixades amb "##", gestió via StringTx.tx()
Mapes: Ús de LdMap<T> en lloc de Map<String, T> arreu del projecte

Arquitectura Three-Layer

Widget Layer: Només configuració, delega al controller

Fitxers: *_widget.dart
Responsabilitat: Configuració UI, delegació al controller


Controller Layer: Gestiona lògica, events i crea models

Fitxers: *_ctrl.dart
Responsabilitat: Lògica de negoci, gestió d'eventos, creació de models


Model Layer: Estat persistent amb pattern Observer

Fitxers: *_model.dart
Responsabilitat: Estat de dades, notificacions de canvis



🏗 Mòduls Principals
Core Components

LdWidgetAbs: Classe base per tots els widgets
LdWidgetCtrlAbs: Classe base per controllers
LdWidgetModelAbs: Classe base per models
LdModelObserverIntf: Interfície per observar canvis

Widgets Implementats

LdButton: Botó amb traduccions i eventos
LdLabel: Etiqueta amb suport RichText
LdTextField: Camp de text (en desenvolupament)

Serveis

TimeService: Gestió del temps amb observers
L (LanguageService): Gestió d'idiomes i traduccions
GlobalVariablesService: Variables automàtiques per interpolació

🎯 Problemes Recents Resolts
Error de Traduccions (Resolt)

Símptoma: Botons mostraven ##sChangeTheme en lloc del text traduït
Causa: LdButtonCtrl no aplicava StringTx.applyTranslation()
Solució: Getter label amb traducció automàtica

Problema LdLabels Reactius (Resolt Definitivament) ⭐️
Context: LdLabels amb arguments d'interpolació no s'actualitzaven quan canviaven les dades del model
Símptomes identificats:

Etiquetes d'hora no s'actualitzaven (TimeService)
Comptadors no mostraven increments
Arguments "congelats" en valors inicials
Logs mostraven notificacions del model però sense reconstrucció consistent

Anàlisi del problema:
dart// ❌ PROBLEMÀTIC: Arguments calculats només a la creació
labCounter = LdLabel(
  pLabel: L.sCounter,
  pPosArgs: [pageModel.counter.toString()], // ← Valor "congelat"
);
model!.attachObserver(labCounter!); // ← Connexió directa problemàtica
Solució implementada - Patró Function Observer:
dart/// Observer per gestionar LdLabels amb dades dinàmiques
late final FnModelObs _obsCounter;

@override
void initialize() {
  // Crear function observer dedicat
  _obsCounter = (LdModelAbs pModel, void Function() pfnUpdate) {
    if (pModel == model && mounted) {
      final count = (model as TestPageModel).counter.toString();
      
      if (labCounter != null) {
        pfnUpdate();
        setState(() {
          labCounter!.setTranslationArgs(positionalArgs: [count]);
        });
      }
    }
  };
  
  // Connectar function observer (NO el LdLabel directament)
  model!.attachObserverFunction(_obsCounter);
}
Regla d'Or establerta: Qualsevol LdLabel que mostri dades que canvien SEMPRE necessita un function observer dedicat que actualitzi els arguments de traducció manualment via setTranslationArgs().
📚 Normes d'Estil i Codificació
1. Sistema de Constants (cf/mf/ef)

cf: Configuration Fields - Camps UI (cfLabel, cfIsEnabled, cfButtonType)
mf: Model Fields - Camps de dades del negoci
ef: Event Fields - Camps d'events

Exemple:
dart// map_fields.dart
const String cfLabel = 'cf_label';
const String cfIsEnabled = 'cf_is_enabled';
const String mfData = 'mf_data';
const String efOnPressed = 'ef_on_pressed';
2. Imports amb Package Complet
dart// ✅ CORRECTE
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/ld_map.dart';

// ❌ INCORRECTE  
import '../../../utils/debug.dart';
import '../../core/ld_map.dart';
3. Interfícies Inline
Patrons per implementar interfícies:
dart// Opció 1: Funció anònima (recomanat)
LdModelObserverIntf obsTimer = (model) {
  // lògica inline
};

// Opció 2: Callback funcional
void Function(LdModelAbs, void Function()) obsTimer = (model, pfUpdate) {
  // lògica inline
};

// Opció 3: Classe anònima
LdModelObserverIntf obsTimer = object : LdModelObserverIntf {
  @override
  void onModelChanged(LdModelAbs model, void Function() pfUpdate) {
    // lògica
  }
};
4. Convencions de Nomenclatura
dart// Classes amb comentaris descriptius
/// Model per al widget LdButton amb suport per traduccions
class LdButtonModel extends LdWidgetModelAbs<LdButton> {

// Alineació consistent
class   LdButtonModel 
extends LdWidgetModelAbs {  // Primera lletra alineada

// Constants descriptives
const String cfButtonType = 'cf_button_type';
const String efOnPressed = 'ef_on_pressed';
5. Comentaris i Documentació
dart/// Classe base per a tots els models de widgets
/// 
/// Proporciona funcionalitat comuna com:
/// - Gestió d'observers
/// - Serialització/deserialització
/// - Notificacions de canvis
abstract class LdWidgetModelAbs<T extends LdWidgetAbs> {
🏗 Sistema de Traduccions i Interpolació
Tipus de Paràmetres Suportats

Paràmetres Posicionals: {0}, {1}, etc.
Paràmetres Nomenats: {name}, {count}, etc.
Variables Automàtiques: {current_date}, {user_name}, etc.

Classes Clau
dart// StringTx - Gestió de traduccions
class StringTx {
  static String tx(String key, [List<String>? positionalArgs, LdMap<String>? namedArgs]);
  static String applyTranslation(String text);
  static String resolveText(String text, List<String>? posArgs, LdMap<String>? namedArgs);
}

// Extensions String
extension StringExtensions on String {
  String get tx => StringTx.tx(this);
  String txWith(List<String> positionalArgs);
  String txArgs(LdMap<String> namedArgs);
  String txFull(List<String> positionalArgs, LdMap<String> namedArgs);
}
Flux de Renderització LdLabel

setTranslationArgs() actualitza arguments al model
label.tx() aplica nous arguments en renderització
StringTx.resolveText() fa interpolació
L.tx() fa traducció final

Exemples d'Ús
dart// Clau simple
"##sCurrentTime".tx // "Hora actual"

// Amb paràmetres posicionals
"##sWelcomeUser".txWith(["Joan"]) // "Benvingut Joan"

// Amb paràmetres nomenats
"##sItemCount".txArgs({"count": "5"}) // "5 elements"

// Combinat
"##sUserStats".txFull(["Joan"], {"points": "100"}) // "Joan té 100 punts"
🔧 Components Clau Implementats
TimeService
dartclass TimeService extends SingletonBase {
  // Singleton instance
  static TimeService get s => _instance ??= TimeService._();
  
  // Model observable
  TimeModel get model => _model;
  
  // Actualitzacio automàtica cada 500ms
  Timer? _timer;
  
  void _updateTime() {
    _model.updateTime();
    _model.notifyListeners();
  }
}
LdLabel amb Traduccions
dartclass LdLabel extends LdWidgetAbs {
  final String? pLabel;
  final List<String>? pPosArgs;
  final LdMap<String>? pNamedArgs;
  
  // Actualització dinàmica d'arguments
  void setTranslationArgs({
    List<String>? positionalArgs,
    LdMap<String>? namedArgs,
  }) {
    wCtrl?.updateTranslationParams(
      positionalArgs: positionalArgs,
      namedArgs: namedArgs,
    );
  }
}
LdModelObserver Pattern
dartabstract class LdModelObserverIntf {
  void onModelChanged(LdModelAbs model, void Function() pfUpdate);
}

// Implementació en models
class LdModelAbs extends ChangeNotifier {
  final List<LdModelObserverIntf> _observers = [];
  
  void attachObserver(LdModelObserverIntf observer) {
    _observers.add(observer);
  }
  
  void detachObserver(LdModelObserverIntf observer) {
    _observers.remove(observer);
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
    for (final observer in _observers) {
      observer.onModelChanged(this, () {});
    }
  }
}
🗂 Estructura de Fitxers
Organització de Carpetes
lib/
├── core/
│   ├── ld_map.dart
│   ├── map_fields.dart
│   └── singleton_base.dart
├── services/
│   ├── time_service.dart
│   ├── L.dart
│   └── global_variables_service.dart
├── ui/
│   ├── widgets/
│   │   ├── ld_button/
│   │   │   ├── ld_button_widget.dart
│   │   │   ├── ld_button_ctrl.dart
│   │   │   └── ld_button_model.dart
│   │   └── ld_label/
│   │       ├── ld_label_widget.dart
│   │       ├── ld_label_ctrl.dart
│   │       └── ld_label_model.dart
│   └── extensions/
│       ├── string_extensions.dart
│       └── map_extensions.dart
├── utils/
│   ├── debug.dart
│   └── string_tx.dart
└── models/
    └── time_model.dart
Convencions de Nomenclatura de Fitxers

Widgets: ld_{component}_widget.dart
Controllers: ld_{component}_ctrl.dart
Models: ld_{component}_model.dart
Extensions: {type}_extensions.dart
Serveis: {name}_service.dart

❌ Errors Comuns que Cometo (A Evitar)
1. Confusió Constants cf/mf/ef
dart// ❌ Error freqüent - usar mf per UI
map[mfLabel] = _label;  // mf és per dades del negoci

// ✅ Correcte - usar cf per UI  
map[cfLabel] = _label;  // cf és per configuració UI
2. Imports amb Paths Relatius
dart// ❌ Error recurrent
import '../../../utils/debug.dart';
import '../../core/ld_map.dart';

// ✅ Correcte - sempre package complet
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/ld_map.dart';
3. Map vs LdMap en Signatures
dart// ❌ Error en tipus de paràmetres
static String tx(String key, Map<String, String>? namedArgs);
void updateData(Map<String, dynamic> data);

// ✅ Correcte - sempre LdMap
static String tx(String key, LdMap<String>? namedArgs);
void updateData(LdMap<dynamic> data);
4. Constructor Sense super()
dart// ❌ Error en constructors
LdButtonModel({required this.label}) : super();

// ✅ Correcte - amb paràmetres adequats
LdButtonModel.fromMap(LdMap<dynamic> pMap) : super.fromMap(pMap);
5. HTML en Comentaris de Documentació
dart// ❌ Error - HTML directe
/// Exemple: LdMap<String>() causa problemes

// ✅ Correcte - HTML escapat
/// Exemple: LdMap&lt;String&gt;() funciona bé
6. Interfícies Inline Incorrectes
dart// ❌ Intent incorrecte (error recent)
LdModelObserverIntf obsTimer = LdModelObserverIntf {
  // codi inline - NO funciona
};

// ✅ Correcte - funció anònima
LdModelObserverIntf obsTimer = (model) {
  // lògica inline que funciona
};
7. No Actualitzar map_fields.dart
dart// ❌ Error - usar constants no definides
map[cfButtonType] = buttonType; // Constant no existeix

// ✅ Correcte - primer afegir la constant
// A map_fields.dart:
const String cfButtonType = 'cf_button_type';
// Després usar-la:
map[cfButtonType] = buttonType;
8. Imports Innecessaris
dart// ❌ Error - imports no utilitzats
import 'package:ld_wbench5/core/map_fields.dart'; // No s'usa directament
import 'package:ld_wbench5/models/user_model.dart'; // No s'usa

// ✅ Correcte - només imports necessaris
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/ld_map.dart';
9. Accessors Redundants
dart// ❌ Error - duplicar funcionalitat existent
LdButtonModel? get model => ctrl?.model as LdButtonModel?; // Ja existeix al pare

// ✅ Correcte - accessor específic
LdButtonModel? get buttonModel => model as LdButtonModel?;
10. Conversions Innecessàries
dart// ❌ Error - conversió costosa innecessària
String txFromMap(Map<String, String> args) {
  final ldMap = LdMap<String>();
  args.forEach((key, value) => ldMap[key] = value);
  return StringTx.tx(this, null, ldMap);
}

// ✅ Correcte - usar LdMap directament
String txArgs(LdMap<String> namedArgs) {
  return StringTx.tx(this, null, namedArgs);
}
11. ⭐️ Error Específic amb LdLabels Reactius (MUY IMPORTANTE)
dart// ❌ Error greu - Connexió directa LdLabel → Model
labCounter = LdLabel(pPosArgs: [model.value.toString()]);
model!.attachObserver(labCounter!); // Arguments "congelats"

// ❌ Error - Modificació manual en onModelChanged
@override
void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
  setState(() {
    (labTime?.model as LdLabelModel).label = newValue; // Salta l'arquitectura
  });
}

// ✅ Correcte - Function Observer dedicat
late final FnModelObs _obsCounter;

_obsCounter = (LdModelAbs pModel, void Function() pfnUpdate) {
  if (pModel == model && mounted) {
    pfnUpdate();
    setState(() {
      labCounter!.setTranslationArgs(positionalArgs: [newValue]);
    });
  }
};

model!.attachObserverFunction(_obsCounter);
📋 Patró Standard per LdLabels Reactius ⭐️
Template Generalitzat
dart/// Observer per gestionar LdLabels amb dades dinàmiques
late final FnModelObs _obs{ComponentName};

@override
void initialize() {
  // 1. Crear model i LdLabel amb arguments inicials
  {labelInstance} = LdLabel(
    pLabel: {translationKey},
    pPosArgs: [{initialValue}], // Valor inicial opcional
  );
  
  // 2. Crear function observer per actualitzar arguments
  _obs{ComponentName} = (LdModelAbs pModel, void Function() pfnUpdate) {
    if (pModel == {sourceModel} && mounted) {
      final {data} = ({sourceModel} as {ModelType}).{dataGetter};
      
      if ({labelInstance} != null) {
        pfnUpdate();
        setState(() {
          {labelInstance}!.setTranslationArgs(
            positionalArgs: [{data}],
            namedArgs: {/* si cal */},
          );
        });
      }
    }
  };
  
  // 3. Connectar function observer (NO el LdLabel directament)
  {sourceModel}.attachObserverFunction(_obs{ComponentName});
}

@override
void dispose() {
  // 4. Important: desconnectar observer
  {sourceModel}?.detachObserverFunction(_obs{ComponentName});
  super.dispose();
}
Casos d'Ús Implementats

TimeService amb actualització d'hora
Comptador amb model local
Etiqueta idioma amb canvi d'idioma

Beneficis del Patró

Predictibilitat: Flux d'actualització clar i consistent
Separació de responsabilitats: Un observer per responsabilitat
Mantenibilitat: Fàcil de debugar i modificar
Reutilització: Patró aplicable a qualsevol LdLabel reactiu

Checklist per Implementar

 Crear function observer específic
 Connectar observer al model font (NO al LdLabel)
 Implementar lògica amb setTranslationArgs()
 Verificar mounted abans de setState()
 Afegir logs de debug adequats
 Desconnectar observer a dispose()

🚀 Estat Actual i Pròxims Passos
✅ Completat

✓ Sistema de traduccions refactoritzat completament
✓ LdButtonCtrl fixat per traduccions
✓ Arquitectura three-layer implementada i estable
✓ Sistema d'interpolació múltiple functional
✓ Patró Observer implementat per LdLabels reactius ⭐️
✓ Problema TimeService i comptador resolt definitivament ⭐️
✓ Extensions String per simplificar traduccions
✓ Documentació completa del patró standard ⭐️

📋 Backlog Prioritat Mitjana

Completar implementació RichText en LdLabel
Aplicar fix de traduccions a LdTextField
Resoldre problemes visuals de selecció de tema
Implementar tests unitaris per components principals

🔧 Millores Futures

Implementar sistema de logs més robust
Afegir support per themes dinàmics
Crear documentació automàtica dels widgets
Implementar testing framework específic per l'arquitectura

🎯 Notes Importants per a Futures Sessions
Característiques del Projecte

⚡ Arquitectura sòlida: Three-layer ben definit i implementat
🌐 Sistema de traduccions avançat: Suport per interpolació complexa
🔄 Pattern Observer robust: Implementat en TimeService i models
📦 Zero Dependencies: Gestió d'estat sense llibreries externes
🎨 Estil consistent: Normes clares i ben documentades
⭐️ LdLabels Reactius: Patró estàndard documentat i funcional

Aspectes Clau a Recordar

Always use LdMap instead of Map - Consistència en tot el projecte
cf/mf/ef conventions are crucial - Error molt freqüent
Package imports always - Mai usar paths relatius
Observer pattern for reactive updates - No usar setState directament en serveis
Translation keys with ## prefix - Sistema establert i functional
⭐️ Function observers per LdLabels reactius - SEMPRE usar aquest patró

Context del Domini
Sabina és més que un framework - és una demostració d'arquitectura Flutter avançada amb:

Gestió d'estat reactiva sense dependencies
Sistema de traduccions i internacionalització complet
Pattern MVC adaptat per Flutter
Componentització avançada amb separation of concerns
⭐️ Patró consolidat per widgets reactius amb actualitzacions automàtiques

Regla d'Or per LdLabels ⭐️

Qualsevol LdLabel que mostri dades que canvien SEMPRE necessita un function observer dedicat que actualitzi els arguments de traducció manualment via setTranslationArgs().

Aquesta síntesi em permet posar-me al dia ràpidament en qualsevol sessió futura, amb especial atenció als errors que tinc tendència a repetir, les normes específiques del projecte, i el patró estàndard per a LdLabels reactius que garanteix actualitzacions correctes.