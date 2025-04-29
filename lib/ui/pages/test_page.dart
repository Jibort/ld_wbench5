// test_page.dart
// Pàgina de prova que mostra la implementació simplificada
// Created: 2025/04/29

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/base_page.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/localization_service.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'test_page_model.dart';

/// Pàgina de prova que mostra la nova arquitectura simplificada
class TestPage extends SabinaPage {
  /// Constructor
  TestPage({Key? key}) 
    : super(
        key: key,
        tag: 'TestPage',
        controller: TestPageController(),
      );
}

/// Controlador per a la pàgina de prova
class TestPageController extends SabinaPageController<TestPage> {
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
    // Aquest mètode es crida quan canvien les dependències
    // No necessitem fer res aquí per ara
  }
  
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos");
    model.detachObserver();
    model.dispose();
    super.dispose();
  }
  
  @override
  void onEvent(SabinaEvent event) {
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
    ThemeService.instance.toggleTheme();
  }
  
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.title),
            if (model.subtitle != null)
              Text(
                model.subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: changeLanguage,
              child: Text(L.sChangeLanguage.tx),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: changeTheme,
              child: Text(L.sChangeTheme.tx),
            ),
          ],
        ),
      ),
    );
  }
}