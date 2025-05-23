// lib/ui/pages/test_page/test_page_ctrl.dart
// Controlador de la pàgina de prova que mostra la implementació simplificada.
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/08 dj. CLA - Actualitzat per utilitzar LdTheme
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_ctrl_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/ui/widgets/ld_old_label/ld_old_label.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_viewer/ld_theme_viewer.dart';
import 'package:ld_wbench5/core/extensions/color_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/services/time_service.dart';

/// Controlador per a la pàgina de prova
class      TestPageCtrl 
extends    LdPageCtrlAbs<TestPage>
implements LdModelObserverIntf {
  // MEMBRES ==============================================
  final String tagLabCounter = LdTaggableMixin.customTag("labCounter");
  final String tagLabLocale  = LdTaggableMixin.customTag("labLocale");
  final String tagLabTime    = LdTaggableMixin.customTag("labTime");

  /// Etiqueta amb el valor del comptador.
  LdLabel? labCounter;
  
  /// Etiqueta amb el codi d'idioma.
  LdLabel? labLocale;
  
  /// Etiqueta amb l'hora actual del servidor.
  LdLabel? labTime;

  /// Referències als controladors dels botons
  LdButtonCtrl? _themeButtonCtrl;
  LdButtonCtrl? _languageButtonCtrl;
  
  /// Key per tenir accés al widget del botó tema
  final GlobalKey<LdButtonCtrl> _themeButtonKey = GlobalKey<LdButtonCtrl>();
  
  /// Key per tenir accés al widget del botó idioma
  final GlobalKey<LdButtonCtrl> _languageButtonKey = GlobalKey<LdButtonCtrl>();

  // CONSTRUCTORS/DESTRUTORS ==============================
  /// Constructor.
  TestPageCtrl({ super.pTag, required super.pPage });

  /// Observer amb FnModelObs - SÚPER CLEAN!
  late final FnModelObs _obsTimer;
  
  /// Observer per al comptador
  late final FnModelObs _obsCounter;

  /// Observer per al comptador
  late final FnModelObs _obsLocale;

  @override
  void initState() {
    super.initState();
    
    // Programar una única actualització després del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllerReferences();
    });
  }

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador");
    
    // Crear el model de la pàgina
    final config = cPage.config;
    final titleKey = config[cfTitleKey] as String? ?? config[mfTitle] as String? ?? L.sAppSabina;
    final subTitleKey = config[cfSubTitleKey] as String? ?? config[mfSubTitle] as String?;
    
    model = TestPageModel(
      pPage: cPage,
      pTitleKey: titleKey,
      pSubTitleKey: subTitleKey,
    );
    
    _obsTimer = (LdModelAbs pModel, void Function() pfnUpdate) {
      if (pModel == TimeService.s.model && mounted) {
        final time = TimeService.s.model.formattedTime;
        
        if (labTime != null) {
          // Executar la funció d'actualització del model
          pfnUpdate();
          
          // Actualitzar els arguments del LdLabel
          // IMPORTANT: No cridar setState() aquí, delegar-ho al controlador del LdLabel
          labTime!.setTranslationArgsIsolated(positionalArgs: [time]);
        }
      }
    };
    
    _obsCounter = (LdModelAbs pModel, void Function() pfnUpdate) {
      if (labCounter != null) {
        // Executar la funció d'actualització del model
        pfnUpdate();
        
        // Actualitzar els arguments del LdLabel
        setState(() {
          labCounter!.setTranslationArgs(positionalArgs: [ "${(pModel as TestPageModel).counter}" ]);
        });
      }
    };

    _obsLocale = (LdModelAbs pModel, void Function() pfnUpdate) {
      if (pModel == model && mounted) {
        final locale = L.getCurrentLocale().languageCode;
        
        if (labLocale != null) {
          pfnUpdate();
          setState(() {
            labLocale!.setTranslationArgs(positionalArgs: [locale]);
          });
        }
      }
    };

    TimeService.s.model.attachObserverFunction(_obsTimer);
    model!.attachObserverFunction(_obsCounter);
    model!.attachObserverFunction(_obsLocale);
    Debug.info("$tag: Model de la pàgina creat");
  }
  
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos");
    
    TimeService.s.model.detachObserverFunction(_obsTimer);
    model?.detachObserverFunction(_obsCounter);
    model?.detachObserverFunction(_obsLocale);
    
    super.dispose();
  }

  // IMPLEMENTACIÓ 'LdLifecycleIntf' ======================
  @override
  void update() {
    // No cal fer res de moment
  }
  
  // IMPLEMENTACIÓ 'LdPageCtrlAbs' ========================
  @override
  void onEvent(LdEvent pEvent) {
    Debug.info("$tag: Event rebut: ${pEvent.eType.name}");

    // Gestionar diferents tipus d'events
    if (pEvent.eType == EventType.languageChanged || 
        pEvent.eType == EventType.rebuildUI) {
      
      // Només reconstruir si està muntat
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció de la UI després del canvi d'event ${pEvent.eType.name}");
        });
      }
    }
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    if (pModel == TimeService.s.model) return;

    Debug.info("$tag.onModelChanged(): executant ...");
    
    // Executar l'actualització sempre
    pfUpdate();
    
    // IMPORTANT: No reconstruir per canvis de TimeService
    if (mounted && pModel != TimeService.s.model) {
      setState(() {
        Debug.info("$tag.onModelChanged(): Reconstruint widget");
      });
    }
    
    Debug.info("$tag.onModelChanged(): ... executat");
  }

  @override
  Widget buildPage(BuildContext context) {
    Debug.info("$tag: INICI buildPage - Stack trace: ${StackTrace.current}");

    final pageModel = model as TestPageModel?;
    Debug.info("$tag: Construint pàgina amb model: títol=${pageModel?.title}, subtítol=${pageModel?.subTitle}");
    
    // Obtenir l'idioma actual cada vegada que es construeix
    String currentLanguage = L.getCurrentLocale().languageCode;
    Debug.info("$tag: Idioma actual: $currentLanguage");

    // Inicialitzem els widgets la primera vegada que es construeix la pàgina
    if (labCounter == null && pageModel != null) {
      labCounter = LdLabel(
        key: ValueKey(tagLabCounter),
        pTag: tagLabCounter,
        pLabel: L.sCounter,
        pPosArgs: [pageModel.counter.toString()],
        style: Theme.of(context).textTheme.bodyMedium,
      );
      // model!.attachObserver(labCounter!);
    }
    
    if (labLocale == null && pageModel != null) {
      labLocale = LdLabel(
        key: ValueKey(tagLabLocale), 
        pTag: tagLabLocale,
        pLabel: L.sCurrentLanguage,
        pPosArgs: [L.getCurrentLocale().languageCode],
        style: Theme.of(context).textTheme.bodyMedium,
      );
      // model!.attachObserver(labLocale!);
    }
    
    // Crear l'etiqueta d'hora si encara no existeix
    labTime ??= LdLabel(
      key: ValueKey(tagLabTime), 
      pTag: tagLabTime,
      pLabel: L.sCurrentTime,
      pPosArgs: [TimeService.s.model.formattedTime],
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    
    // Creem una referència al TextField (amb Key per evitar que es recreï)
    final textField = LdTextField(
      key: const ValueKey('my_text_field'),
      initialText: "Z>",
      label: L.sTextField,
      helpText: L.sTextFieldHelp,
    );

    // Botó per afegir "A" al text
    final addButton = ElevatedButton(
      onPressed: () {
        // Modifiquem directament el model del widget
        textField.appendText("A");
      },
      child: Text("Afegir 'A'"),
    );

    // Creem els botons i guardem referència als seus controladors mitjançant keys
    final themeButton = LdButton(
      key: _themeButtonKey,
      text: L.sChangeTheme,
      onPressed: changeTheme,
      // backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    
    final languageButton = LdButton(
      key: _languageButtonKey,
      text: L.sChangeLanguage,
      onPressed: changeLanguage,
    );
    
    final toggleVisibilityButton = LdButton(
      text: L.sToggleThemeButtonVisibility,
      onPressed: toggleThemeButtonVisibility,
    );

    final toggleEnabledButton = LdButton(
      text: L.sToggleLanguageButtonEnabled,
      onPressed: toggleLanguageButtonEnabled,
    );
    
    Debug.info("$tag: FI buildPage");

    return LdScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LdAppBar(
          pTitleKey: pageModel?.title ?? L.sAppSabina,
          pSubTitleKey: pageModel?.subTitle,
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          // Permet fer tap fora del camp per tancar el teclat
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            // Scaffold sense appBar dins del body del LdScaffold principal
            backgroundColor: Colors.transparent,
            // Usar resizeToAvoidBottomInset per gestionar el teclat
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              // SingleChildScrollView permet fer scroll quan apareix el teclat
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Subtítol
                    if (pageModel?.subTitle != null)
                    LdLabel(
                      key: ValueKey('subtitle_${pageModel!.subTitle}'),
                      pLabel: pageModel.subTitle!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Widget d'hora - Nova secció
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.setOpacity(0.1),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: labTime!,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Mostrar comptador
                    labCounter!,
                    
                    // Mostrar idioma actual
                    labLocale!,
                    
                    const SizedBox(height: 24),
                    
                    // Secció dels botons principals
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          // Botó per canviar idioma
                          languageButton,
                          
                          const SizedBox(height: 16),
                          
                          // Botó per canviar tema
                          themeButton,
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // NOU: Selector de temes complet
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LdThemeSelector(
                        pTag: "ThemeSelector_TestPage",
                        pfnOnModeChanged: (mode) {
                          Debug.info("$tag: Canvi de mode de tema des del selector: ${mode.toString()}");
                        },
                        pfnOnThemeChanged: (theme) {
                          Debug.info("$tag: Canvi de tema des del selector: $theme");
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // NOU: Visualitzador de temes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ExpansionTile(
                        title: Text(
                          "Visualitzador de tema actual",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        children: [
                          LdThemeViewer(
                            pTag: "ThemeViewer_TestPage",
                            // Mostrar en mode compacte per estalviar espai
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                    // Secció dels botons de demostració
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.setOpacity(0.1),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LdLabel(
                            key: ValueKey('features_demo'),
                            pLabel: L.sFeaturesDemo,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          toggleVisibilityButton,
                          const SizedBox(height: 12),
                          toggleEnabledButton,
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: textField,
                    ),
                    addButton,
                    // Afegir un espai extra al final per assegurar que hi ha suficient espai
                    // quan el teclat està visible
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Debug.info("$tag: Botó flotant premut");
                
                // NOMÉS modifiquem el model, mai manipulem directament els LdText
                (model as TestPageModel?)?.incrementCounter();
                
                // // Demo: demanar focus al botó de tema quan el comptador és parell
                // if ((pageModel?.counter ?? 0) % 2 == 0) {
                //   // Ens assegurem de tenir els controladors
                //   _updateControllerReferences();
                  
                //   if (_themeButtonCtrl != null && _themeButtonCtrl!.isVisible) {
                //     _themeButtonCtrl!.requestFocus();
                //   }
                // }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  // FUNCIONALITAT ========================================
  /// Canvia l'idioma entre català i espanyol
  void changeLanguage() {
    Debug.info("$tag: Canviant idioma");
    L.toggleLanguage();
    (model as TestPageModel?)?.changeLocale();
  }
  
  /// Canvia el tema entre clar i fosc
  void changeTheme() {
    Debug.info("$tag: Canviant tema");
    ThemeService.s.toggleTheme();
  }
  
  
  /// Alterna la visibilitat del botó de tema
  void toggleThemeButtonVisibility() {
    Debug.info("$tag: Alternant visibilitat del botó de tema");
    
    // Ens assegurem de tenir els controladors
    _updateControllerReferences();
    
    if (_themeButtonCtrl != null) {
      _themeButtonCtrl!.toggleVisibility();
      Debug.info("$tag: Visibilitat del botó de tema alternada a ${_themeButtonCtrl!.isVisible}");
    } else {
      Debug.error("$tag: No s'ha pogut obtenir el controlador del botó de tema");
    }
  }
  
  /// Alterna l'estat d'activació del botó d'idioma
  void toggleLanguageButtonEnabled() {
    Debug.info("$tag: Alternant estat d'activació del botó d'idioma");
    
    // Ens assegurem de tenir els controladors
    _updateControllerReferences();
    
    if (_languageButtonCtrl != null) {
      _languageButtonCtrl!.toggleEnabled();
      Debug.info("$tag: Estat d'activació del botó d'idioma alternat a ${_languageButtonCtrl!.isEnabled}");
    } else {
      Debug.error("$tag: No s'ha pogut obtenir el controlador del botó d'idioma");
    }
  }

  /// Obté accés als controladors dels botons després que s'hagin creat
  void _updateControllerReferences() {
    // Intentem obtenir el controlador del botó de tema
    if (_themeButtonKey.currentState != null) {
      _themeButtonCtrl = _themeButtonKey.currentState!;
      Debug.info("$tag: Controlador del botó de tema obtingut correctament");
    }
    
    // Intentem obtenir el controlador del botó d'idioma
    if (_languageButtonKey.currentState != null) {
      _languageButtonCtrl = _languageButtonKey.currentState!;
      Debug.info("$tag: Controlador del botó d'idioma obtingut correctament");
    }
  }
}