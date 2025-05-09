// lib/ui/pages/test_page/test_page_ctrl.dart
// Controlador de la pàgina de prova que mostra la implementació simplificada.
// Created: 2025/04/29 DT. CLA[JIQ]
// Updated: 2025/05/08 dj. CLA - Actualitzat per utilitzar LdTheme

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/services/ld_theme.dart'; // Importem el nou servei
import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_viewer/ld_theme_viewer.dart';
import 'package:ld_wbench5/ui/extensions/color_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/services/time_service.dart';

/// Controlador per a la pàgina de prova
class   TestPageCtrl 
extends LdPageCtrl<TestPage> {
  /// Etiqueta amb el valor del comptador.
  LdLabel? labCounter;
  
  /// Etiqueta amb el codi d'idioma.
  LdLabel? labLocale;
  
  /// Etiqueta amb l'hora actual del servidor.
  LdLabel? labTime;

  /// Model de dades de la pàgina
  TestPageModel get model => cPage.vModel as TestPageModel;

  /// Referències als controladors dels botons
  LdButtonCtrl? _themeButtonCtrl;
  LdButtonCtrl? _languageButtonCtrl;
  
  /// Key per tenir accés al widget del botó tema
  final GlobalKey<LdButtonCtrl> _themeButtonKey = GlobalKey<LdButtonCtrl>();
  
  /// Key per tenir accés al widget del botó idioma
  final GlobalKey<LdButtonCtrl> _languageButtonKey = GlobalKey<LdButtonCtrl>();

  /// Constructor.
  TestPageCtrl({ super.pTag, required super.pPage });

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador");
    model.attachObserver(this);
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos");
    
    // Desregistrar els widgets de tots els models externs
    if (labCounter != null) {
      model.detachObserver(labCounter!);
    }
    
    if (labLocale != null) {
      model.detachObserver(labLocale!);
    }
    
    if (labTime != null) {
      // Desregistrar del model d'hora
      TimeService.s.model.detachObserver(labTime!);
    }
    
    model.detachObserver(this);
    model.dispose();
    super.dispose();
  }

  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Event rebut: ${event.eType.name}");

    // Gestionar diferents tipus d'events
    if (event.eType == EventType.languageChanged || 
        event.eType == EventType.rebuildUI) {
      
      // Només reconstruir si està muntat
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció de la UI després del canvi d'event ${event.eType.name}");
        });
      }
    }
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    Debug.info("$tag.onModelChanged(): executant ...");
    
    // Executar l'actualització
    pfUpdate();
    
    // Forçar una reconstrucció per assegurar que tots els widgets fills 
    // (incloent-hi LdText) obtenen el valor actualitzat
    if (mounted) {
      setState(() {
        Debug.info("$tag.onModelChanged(): ... executat amb reconstrucció");
      });
    } else {
      Debug.info("$tag.onModelChanged(): ... executat sense reconstrucció");
    }
  }
    
  /// Canvia l'idioma entre català i espanyol
  void changeLanguage() {
    Debug.info("$tag: Canviant idioma");
    L.toggleLanguage();
    model.changeLocele();
  }
  
  /// Canvia el tema entre clar i fosc
  void changeTheme() {
    Debug.info("$tag: Canviant tema");
    LdTheme.s.toggleTheme(); // Utilitzem LdTheme directament
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

  @override
  Widget buildPage(BuildContext context) {
    // Inicialitzem per assegurar-nos que tenim els controladors dels botons
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllerReferences();
    });
    
    Debug.info("$tag: Construint pàgina amb model: títol=${model.title}, subtítol=${model.subTitle}");
    
    // Obtenir l'idioma actual cada vegada que es construeix
    String currentLanguage = L.getCurrentLocale().languageCode;
    Debug.info("$tag: Idioma actual: $currentLanguage");

    // Inicialitzem els widgets la primera vegada que es construeix la pàgina
    if (labCounter == null) {
      labCounter = LdLabel(
        key: ValueKey('counter_${model.counter}'),
        text: L.sCounter,
        args: [model.counter],
        style: Theme.of(context).textTheme.bodyMedium,
      );
      labCounter!.registerModelCallback<TestPageModel>(model, (pModel) {
        labCounter!.args = [pModel.counter];
      });
    }
    
    if (labLocale == null) {
      labLocale = LdLabel(
        key: ValueKey('language_${L.getCurrentLocale().languageCode}'),
        text: L.sCurrentLanguage,
        args: [L.getCurrentLocale().languageCode],
        style: Theme.of(context).textTheme.bodyMedium,
      );
      labLocale!.registerModelCallback<TestPageModel>(model, (pModel) {
        labLocale!.args = [L.getCurrentLocale().languageCode];
      });
    }
    
    // Crear l'etiqueta d'hora si encara no existeix
    if (labTime == null) {
      labTime = LdLabel(
        key: const ValueKey('time_label'),
        text: "Hora actual: {0}",  // Usem un placeholder {0} que serà substituït per l'hora
        args: [TimeService.s.model.formattedTime],  // Inicialitzem amb l'hora actual
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
      
      // Registrar callback per quan canviï el model d'hora
      labTime!.registerModelCallback<TimeModel>(TimeService.s.model, (pModel) {
        // Actualitzar només l'argument amb l'hora actualitzada
        labTime!.args = [pModel.formattedTime];
      });
    }

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
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
    
    return LdScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LdAppBar(
          pTitleKey: model.title,
          pSubTitleKey: model.subTitle,
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
                    if (model.subTitle != null)
                    LdLabel(
                      key: ValueKey('subtitle_${model.subTitle}'),
                      text: model.subTitle!,
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
                        onModeChanged: (mode) {
                          Debug.info("$tag: Canvi de mode de tema des del selector: ${mode.toString()}");
                        },
                        onThemeChanged: (theme) {
                          Debug.info("$tag: Canvi de tema des del selector: ${LdTheme.s.getThemeNameString(theme)}");
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // NOU: Selector de temes complet
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LdThemeSelector(
                        pTag: "ThemeSelector_TestPage",
                        onModeChanged: (mode) {
                          Debug.info("$tag: Canvi de mode de tema des del selector: ${mode.toString()}");
                        },
                        onThemeChanged: (theme) {
                          Debug.info("$tag: Canvi de tema des del selector: ${LdTheme.s.getThemeNameString(theme)}");
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
                            text: L.sFeaturesDemo,
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
                model.incrementCounter();
                
                // Demo: demanar focus al botó de tema quan el comptador és parell
                if (model.counter % 2 == 0) {
                  // Ens assegurem de tenir els controladors
                  _updateControllerReferences();
                  
                  if (_themeButtonCtrl != null && _themeButtonCtrl!.isVisible) {
                    _themeButtonCtrl!.requestFocus();
                  }
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}