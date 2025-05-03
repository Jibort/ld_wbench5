// lib/ui/pages/test_page/test_page_ctrl.dart

// Controlador de la pàgina de prova que mostra la implementació simplificada.
// Exemple d'ús de les noves característiques del LdButton en una pàgina
// Created: 2025/04/29 DT. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
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
    
    // Actualitzar model quan canvia l'idioma
    if (event.eType == EventType.languageChanged) {
      String? newLocale = event.eData[mfNewLocale] as String?;
      Debug.info("$tag: Idioma canviat a: $newLocale");
      
      // Actualitzar els textos del model
      model.updateTexts();
      
      // També forcem una actualització global a tota l'aplicació
      // per assegurar-nos que tots els widgets rebin l'esdeveniment
      EventBus.s.emit(LdEvent(
        eType: EventType.rebuildUI,
        srcTag: tag,
        eData: {},
      ));
      
      // Forçar una reconstrucció de la UI
      setState(() {
        // Aquest setState() forçarà a reconstruir la UI amb els nous textos
        Debug.info("$tag: Forçant reconstrucció de la UI després del canvi d'idioma");
      });
    }
  }

  /// 'LdModelObserver': Respon als canvis del model de dades.
  @override
  void onModelChanged(void Function() pfUpdate) {
    Debug.info("$tag.onModelChanged(): executant ...");
    
    // Executar l'actualització i forçar una reconstrucció de la UI
    if (mounted) {
      setState(pfUpdate);
      Debug.info("$tag.onModelChanged(): ... executat amb reconstrucció");
    } else {
      pfUpdate();
      Debug.info("$tag.onModelChanged(): ... executat sense reconstrucció");
    }
  }
  
  /// Canvia l'idioma entre català i espanyol
  void changeLanguage() {
    Debug.info("$tag: Canviant idioma");
    L.toggleLanguage();
    
    // Com a backup, també forcem una actualització aquí per si l'esdeveniment no es rebés
    Future.delayed(const Duration(milliseconds: 100), () {
      model.updateTexts();
      
      // Emetre un esdeveniment de reconstrucció de la UI per a tota l'aplicació
      EventBus.s.emit(LdEvent(
        eType: EventType.rebuildUI,
        srcTag: tag,
      ));
      
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció de la UI després del canvi d'idioma (backup)");
        });
      }
    });
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
    
    // Mostrar l'idioma actual
    String currentLanguage = L.getCurrentLocale().languageCode;
    Debug.info("$tag: Idioma actual: $currentLanguage");
    
    // Creem els botons i guardem referència als seus controladors mitjançant keys
    final themeButton = LdButton(
      key: _themeButtonKey,
      text: L.sChangeTheme.tx,
      onPressed: changeTheme,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    
    final languageButton = LdButton(
      key: _languageButtonKey,
      text: L.sChangeLanguage.tx,
      onPressed: changeLanguage,
    );
    
    final toggleVisibilityButton = LdButton(
      text: "Alternar visibilitat botó tema",
      onPressed: toggleThemeButtonVisibility,
    );
    
    final toggleEnabledButton = LdButton(
      text: "Alternar estat botó idioma",
      onPressed: toggleLanguageButtonEnabled,
    );
    
    return LdScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LdAppBar(
          pTitle: model.title,
          pSubTitle: model.subTitle,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Subtítol
            if (model.subTitle != null)
              Text(
                model.subTitle!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            
            const SizedBox(height: 16),
            
            // Mostrar comptador
            Text(
              'Comptador: ${model.counter}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            // Mostrar idioma actual
            Text(
              'Idioma actual: $currentLanguage',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
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
                  Text(
                    'Demostració de característiques:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  toggleVisibilityButton,
                  const SizedBox(height: 12),
                  toggleEnabledButton,
                ],
              ),
            ),
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