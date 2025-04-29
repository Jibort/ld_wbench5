// test_page.dart
// Pàgina de prova que mostra la implementació simplificada
// Created: 2025/04/29 DT. CLA[JIQ]

// lib/ui/pages/test_page.dart
import 'package:flutter/material.dart';

import 'test_page_model.dart';
import 'package:ld_wbench5/core/ld_page.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/widgets/sabina_app_bar.dart';
import 'package:ld_wbench5/ui/widgets/sabina_button.dart';
import 'package:ld_wbench5/ui/widgets/sabina_scaffold.dart';


/// Pàgina de prova que mostra la nova arquitectura simplificada
class TestPage extends LdPage {
  /// Constructor
  TestPage({super.key}) 
    : super(
        pTag: 'TestPage',
        ctrl: TestPageController(),
      );
}

/// Controlador per a la pàgina de prova
class TestPageController extends LdPageCtrl<TestPage> {
  /// Model de dades de la pàgina
  late final TestPageModel model;
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador");
    
    // Crear i inicialitzar el model
    model = TestPageModel();
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
    Debug.info("$tag: Event rebut: ${event.type}");
    
    // Actualitzar model quan canvia l'idioma
    if (event.type == EventType.languageChanged) {
      String? newLocale = event.data[mfNewLocale] as String?;
      Debug.info("$tag: Idioma canviat a: $newLocale");
      model.updateTexts();
    }
  }
  
  /// Canvia l'idioma entre català i espanyol
  void changeLanguage() {
    Debug.info("$tag: Canviant idioma");
    L.toggleLanguage();
    
  }
  
  /// Canvia el tema entre clar i fosc
  void changeTheme() {
    Debug.info("$tag: Canviant tema");
    ThemeService.inst.toggleTheme();
  }
  
  @override
  Widget buildPage(BuildContext context) {
    return SabinaScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SabinaAppBar(
          title: model.title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Subtítol
            if (model.subtitle != null)
              Text(
                model.subtitle!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            
            const SizedBox(height: 16),
            
            // Mostrar comptador
            Text(
              'Comptador: ${model.counter}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const SizedBox(height: 16),
            
            // Botó per canviar idioma
            SabinaButton(
              text: L.sChangeLanguage.tx,
              onPressed: changeLanguage,
            ),
            
            const SizedBox(height: 16),
            
            // Botó per canviar tema
            SabinaButton(
              text: L.sChangeTheme.tx,
              onPressed: changeTheme,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Debug.info("$tag: Botó flotant premut");
          // Incrementar el comptador
          model.incrementCounter();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}