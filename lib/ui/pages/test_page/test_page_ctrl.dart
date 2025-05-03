// lib/ui/pages/test_page/test_page_ctrl.dart

// Controlador de la pàgina de prova que mostra la implementació simplificada.
// Exemple d'ús de les noves característiques del LdButton en una pàgina
// Created: 2025/04/29 DT. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA

import 'package:flutter/material.dart';

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
    ThemeService.s.toggleTheme();
  }
  
  /// Alterna la visibilitat del botó de tema
  void toggleThemeButtonVisibility() {
    Debug.info("$tag: Alternant visibilitat del botó de tema");
    if (_themeButtonCtrl != null) {
      _themeButtonCtrl!.toggleVisibility();
    }
  }
  
  /// Alterna l'estat d'activació del botó d'idioma
  void toggleLanguageButtonEnabled() {
    Debug.info("$tag: Alternant estat d'activació del botó d'idioma");
    if (_languageButtonCtrl != null) {
      _languageButtonCtrl!.toggleEnabled();
    }
  }
  
  @override
  Widget buildPage(BuildContext context) {
    // Creem els botons i guardem referència als seus controladors
    final themeButton = LdButton(
      text: L.sChangeTheme.tx,
      onPressed: changeTheme,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    _themeButtonCtrl = themeButton.wCtrl as LdButtonCtrl;
    
    final languageButton = LdButton(
      text: L.sChangeLanguage.tx,
      onPressed: changeLanguage,
    );
    _languageButtonCtrl = languageButton.wCtrl as LdButtonCtrl;
    
    // Ja no guardem la referència a aquest controlador perquè no s'utilitza
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
          title: model.title,
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
          if (model.counter % 2 == 0 && _themeButtonCtrl != null && _themeButtonCtrl!.isVisible) {
            _themeButtonCtrl!.requestFocus();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import 'package:ld_wbench5/core/event_bus/ld_event.dart';
// import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
// import 'package:ld_wbench5/core/map_fields.dart';
// import 'package:ld_wbench5/services/L.dart';
// import 'package:ld_wbench5/services/theme_service.dart';
// import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
// import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
// import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
// import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
// import 'package:ld_wbench5/utils/debug.dart';

// /// Controlador per a la pàgina de prova
// class   TestPageCtrl 
// extends LdPageCtrl<TestPage> {
//   /// Model de dades de la pàgina
//   TestPageModel get model => cPage.vModel as TestPageModel;

//   /// Constructor.
//   TestPageCtrl({ super.pTag, required super.pPage });
  
//   @override
//   void initialize() {
//     Debug.info("$tag: Inicialitzant controlador");
    
//     // Crear i inicialitzar el model
//     // El model es crea amb els paràmetres rebuts pel constructor.
//     // model = TestPageModel();
//     model.attachObserver(this);
//   }
  
//   @override
//   void update() {
//     // No cal fer res de moment
//   }
  
//   @override
//   void dispose() {
//     Debug.info("$tag: Alliberant recursos");
//     model.detachObserver();
//     model.dispose();
//     super.dispose();
//   }
  
//   @override
//   void onEvent(LdEvent event) {
//     Debug.info("$tag: Event rebut: ${event.eType.name}");
    
//     // Actualitzar model quan canvia l'idioma
//     if (event.eType == EventType.languageChanged) {
//       String? newLocale = event.eData[mfNewLocale] as String?;
//       Debug.info("$tag: Idioma canviat a: $newLocale");
//       model.updateTexts();
//     }
//   }
  
//   /// Canvia l'idioma entre català i espanyol
//   void changeLanguage() {
//     Debug.info("$tag: Canviant idioma");
//     L.toggleLanguage();
    
//   }
  
//   /// Canvia el tema entre clar i fosc
//   void changeTheme() {
//     Debug.info("$tag: Canviant tema");
//     ThemeService.s.toggleTheme();
//   }
  
//   @override
//   Widget buildPage(BuildContext context) {
//     return LdScaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: LdAppBar(
//           title: model.title,
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Subtítol
//             if (model.subTitle != null)
//               Text(
//                 model.subTitle!,
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
            
//             const SizedBox(height: 16),
            
//             // Mostrar comptador
//             Text(
//               'Comptador: ${model.counter}',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
            
//             const SizedBox(height: 16),
            
//             // Botó per canviar idioma
//             LdButton(
//               text: L.sChangeLanguage.tx,
//               onPressed: changeLanguage,
//             ),
            
//             const SizedBox(height: 16),
            
//             // Botó per canviar tema
//             LdButton(
//               text: L.sChangeTheme.tx,
//               onPressed: changeTheme,
//               backgroundColor: Theme.of(context).colorScheme.secondary,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Debug.info("$tag: Botó flotant premut");
//           // Incrementar el comptador
//           model.incrementCounter();
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }