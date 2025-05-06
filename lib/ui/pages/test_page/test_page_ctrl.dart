// lib/ui/pages/test_page/test_page_ctrl.dart

// Controlador de la pàgina de prova que mostra la implementació simplificada.
// Exemple d'ús de les noves característiques del LdButton en una pàgina
// Created: 2025/04/29 DT. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/ui/widgets/ld_text/ld_text.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/color_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador per a la pàgina de prova
class   TestPageCtrl 
extends LdPageCtrl<TestPage> {
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
    model.detachObserver();
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

  // CLA_1:@override
  // CLA_1:void onEvent(LdEvent event) {
  // CLA_1:  Debug.info("$tag: Event rebut: ${event.eType.name}");
  // CLA_1:
  // CLA_1:  // Actualizar modelo cuando cambia el idioma
  // CLA_1:  if (event.eType == EventType.languageChanged) {
  // CLA_1:    String? newLocale = event.eData[mfNewLocale] as String?;
  // CLA_1:    Debug.info("$tag: Idioma canviat a: $newLocale");
  // CLA_1: 
  // CLA_1:    // Actualizar los textos del modelo
  // CLA_1:    // JAB_Q: No cal, oi? model.updateTexts();
  // CLA_1: 
  // CLA_1:    // Forzar reconstrucción de la UI
  // CLA_1:    if (mounted) {
  // CLA_1:      setState(() {
  // CLA_1:        Debug.info("$tag: Forçant reconstrucció de la UI després del canvi d'idioma");
  // CLA_1:      });
  // CLA_1:    }
  // CLA_1:  }
  // CLA_1:
  // CLA_1:  // Manejamos rebuildUI por separado
  // CLA_1:  else if (event.eType == EventType.rebuildUI) {
  // CLA_1:    if (mounted) {
  // CLA_1:      setState(() {
  // CLA_1:        Debug.info("$tag: Reconstruint completament");
  // CLA_1:      });
  // CLA_1:    }
  // CLA_1:  }
  // CLA_1:}

  @override
  void onModelChanged(void Function() pfUpdate) {
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

  // CLA_2: /// 'LdModelObserver': Respon als canvis del model de dades.
  // CLA_2: @override
  // CLA_2: void onModelChanged(void Function() pfUpdate) {
  // CLA_2:   Debug.info("$tag.onModelChanged(): executant ...");
  // CLA_2:  
  // CLA_2:   // Executar l'actualització i forçar una reconstrucció de la UI
  // CLA_2:   if (mounted) {
  // CLA_2:     setState(pfUpdate);
  // CLA_2:     Debug.info("$tag.onModelChanged(): ... executat amb reconstrucció");
  // CLA_2:   } else {
  // CLA_2:     pfUpdate();
  // CLA_2:     Debug.info("$tag.onModelChanged(): ... executat sense reconstrucció");
  // CLA_2:   }
  // CLA_2: }
  
  /// Canvia l'idioma entre català i espanyol
  void changeLanguage() {
    Debug.info("$tag: Canviant idioma");
    L.toggleLanguage();
  }
  
  /// Canvia el tema entre clar i fosc
  void changeTheme() {
    Debug.info("$tag: Canviant tema");
    ThemeService.s.toggleTheme();
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
    // Inicialitzem per assegurar-nos que tenim els controladors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllerReferences();
    });
    
    Debug.info("$tag: Construint pàgina amb model: títol=${model.title}, subtítol=${model.subTitle}");
    
    // Obtenir l'idioma actual cada vegada que es construeix
    String currentLanguage = L.getCurrentLocale().languageCode;
    Debug.info("$tag: Idioma actual: $currentLanguage");

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
      text: L.sChangeTheme, // JAB_Q: .tx, // Ya usa correctamente .tx
      onPressed: changeTheme,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    
    final languageButton = LdButton(
      key: _languageButtonKey,
      text: L.sChangeLanguage, // JAB_Q: .tx, // Ya usa correctamente .tx
      onPressed: changeLanguage,
    );
    
    // Asegurarnos de que todos los textos estáticos usen la traducción correcta
    final toggleVisibilityButton = LdButton(
      text: L.sToggleThemeButtonVisibility, // JAB_Q: .tx,
      onPressed: toggleThemeButtonVisibility,
    );

    final toggleEnabledButton = LdButton(
      text: L.sToggleLanguageButtonEnabled, // JAB_Q: .tx,
      onPressed: toggleLanguageButtonEnabled,
    );
    
    return LdScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LdAppBar(
          pTitleKey:    model.title,
          pSubTitleKey: model.subTitle,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Subtítol
            if (model.subTitle != null)
            LdText(
              text: model.subTitle!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // CLA_2: Text(
            // CLA_2:   model.subTitle!.tx,
            // CLA_2:   style: Theme.of(context).textTheme.bodyLarge,
            // CLA_2: ),
            
            const SizedBox(height: 16),
            
            // Mostrar comptador
            LdText(
              key:  ValueKey(model.counter), // Clau única que força reconstrucció
              text: L.sCounter,
              args: [model.counter],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // CLA_2.1: LdText(
            // CLA_2.1:   text: L.sCounter,
            // CLA_2.1:   args: [model.counter],
            // CLA_2.1:   style: Theme.of(context).textTheme.bodyMedium,
            // CLA_2.1: ),
            // CLA_2: Text(
            // CLA_2:   'Comptador: ${model.counter}',
            // CLA_2:   style: Theme.of(context).textTheme.bodyMedium,
            // CLA_2: ),
            
            // Mostrar idioma actual
            LdText(
              text: L.sCurrentLanguage,
              args: [currentLanguage],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // CLA_2: Text(
            // CLA_2:   'Idioma actual: $currentLanguage',
            // CLA_2:   style: Theme.of(context).textTheme.bodyMedium,
            // CLA_2: ),
            
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
            
            const SizedBox(height: 40),
            
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
                  LdText(
                    text: L.sFeaturesDemo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // CLA_2: Text(
                  // CLA_2:   'Demostració de característiques:',
                  // CLA_2:   style: Theme.of(context).textTheme.titleMedium,
                  // CLA_2: ),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Debug.info("$tag: Botó flotant premut");
          // Incrementar el comptador
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
    );
  }

}