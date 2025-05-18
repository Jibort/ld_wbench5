// lib/ui/pages/test_page2/test_page2_ctrl.dart
// Controlador de la pàgina de proves 2
// Created: 2025/05/17 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_ctrl_abs.dart';
import 'package:ld_wbench5/core/extensions/color_extensions.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/pages/test_page2/test_page2.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/ui/widgets/ld_text_field/ld_text_field.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador per a la pàgina de proves 2
class TestPage2Ctrl extends LdPageCtrlAbs<TestPage2> {
  // MEMBRES ==============================================
  /// Referència a contenidors plegables per a manipulació programàtica
  final Map<String, LdFoldableContainer> _foldableContainers = {};
  
  // PERSISTÈNCIA D'ESTAT =================================
  /// Map per desar l'estat entre reconstruccions
  static final MapDyns _persistentState = MapDyns();
  
  // CONSTRUCTORS/DESTRUCTORS ============================
  /// Constructor
  TestPage2Ctrl({super.pTag, required super.pPage});

  @override
  void initialize() {
    // Crear el model de la pàgina
    final config = cPage.config;
    final titleKey = config[cfTitleKey] as String? ?? config[mfTitle] as String? ?? L.sAppSabina;
    final subTitleKey = config[cfSubTitleKey] as String? ?? config[mfSubTitle] as String?;
    
    // Recuperar valors persistents o crear nous
    if (_persistentState.isEmpty) {
      // Primera inicialització - guardar valors per defecte
      model = TestPage2Model(
        pPage: cPage,
        pTitleKey: titleKey,
        pSubTitleKey: subTitleKey,
      );
      
      // Inicialitzar valors per defecte
      _persistentState['saved_text_field_value'] = "";
      _persistentState[mfCounter] = 0;
      
      Debug.info("$tag: Creat nou model de pàgina");
    } else {
      // Restauració d'un estat previ
      try {
        // Recuperar l'estat del model
        model = TestPage2Model.fromMap(cPage, _persistentState);
        Debug.info("$tag: Restaurat model de pàgina des d'estat persistent");
      } catch (e) {
        // Si hi ha error en restaurar, crear un nou model
        Debug.error("$tag: Error restaurant model: $e");
        model = TestPage2Model(
          pPage: cPage,
          pTitleKey: titleKey,
          pSubTitleKey: subTitleKey,
        );
      }
    }
  }
  
  @override
  void update() {
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  void dispose() {
    // Només guardar l'estat si el model no és null
    if (model != null) {
      // Desar l'estat actual per a futures reconstruccions
      _saveState();
    }
    
    super.dispose();
  }

  /// Guarda l'estat actual per a futures reconstruccions
  void _saveState() {
    final currentModel = model as TestPage2Model?;
    if (currentModel != null) {
      // Convertir el model a un mapa i guardar-lo
      final modelMap = currentModel.toMap();
      
      // Només actualitzar els camps que existeixen (no sobreescriure tot)
      for (final entry in modelMap.entries) {
        _persistentState[entry.key] = entry.value;
      }
      
      Debug.info("$tag: Estat del model desat per a persistència");
    }
  }

  @override
  void onEvent(LdEvent event) {
    // Gestionar diferents tipus d'events
    if (event.eType == EventType.languageChanged || 
        event.eType == EventType.themeChanged || 
        event.eType == EventType.rebuildUI) {
      
      // Guardar l'estat abans de la reconstrucció
      _saveState();
      
      // Només reconstruir si està muntat
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    // Executar l'acció d'actualització
    pfnUpdate();
    
    // Guardar l'estat quan canvia el model
    _saveState();
    
    // Reconstruir si està muntat
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    final pageModel = model as TestPage2Model?;
    if (pageModel == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Actualitzar l'estat persistit amb les dades actuals del model
    _persistentState[mfCounter] = pageModel.counter;
    
    // Netegem referències antigues als contenidors
    _foldableContainers.clear();
    
    return LdScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LdAppBar(
          pTitleKey: pageModel.title,
          pSubTitleKey: pageModel.subTitle,
        ),
      ),
      body: SafeArea(
        // Utilitzem ListView en lloc de SingleChildScrollView per millor rendiment
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Contenidor dels components bàsics
            _buildBasicComponentsSection(context),
            
            const SizedBox(height: 16),
            
            // Contenidor dels components d'entrada i formularis
            _buildInputComponentsSection(context),
            
            // Comentem temporalment aquests contenidors per identificar el problema
            // const SizedBox(height: 16),
            
            // // Contenidor dels components de temes i estils
            // _buildThemeComponentsSection(context),
            
            // const SizedBox(height: 16),
            
            // // Contenidor dels components avançats
            // _buildAdvancedComponentsSection(context),
            
            // const SizedBox(height: 16),
            
            // // Contenidor per a configuracions de LdFoldableContainer
            // _buildFoldableContainerDemoSection(context),
            
            const SizedBox(height: 16),
            
            // Botó per expandir/contreure tots els contenidors
            LdButton(
              text: "Toggle All Containers",
              onPressed: _toggleAllContainers,
            ),
            
            // Espai extra al final
            const SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (model != null) {
            (model as TestPage2Model).incrementCounter();
            // Actualitzar també l'estat persistent directament per seguretat
            _persistentState[mfCounter] = (model as TestPage2Model).counter;
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // SECCIONS DE LA PÀGINA ================================
  
  /// Construeix la secció de components bàsics
  Widget _buildBasicComponentsSection(BuildContext context) {
    final container = LdFoldableContainer(
      pTag: "BasicComponentsContainer",
      titleKey: "Components Bàsics",
      subtitleKey: "Labels, Buttons, etc.",
      initialExpanded: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // LdLabel
          LdLabel(
            pLabel: "##sWelcome",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          
          const SizedBox(height: 8),
          
          // LdButton
          LdButton(
            text: L.sChangeLanguage,
            onPressed: () {
              // Guardar estat abans de canviar l'idioma
              _saveState();
              L.toggleLanguage();
            },
          ),
          
          const SizedBox(height: 8),
          
          // LdButton amb tema diferent
          LdButton(
            text: L.sChangeTheme,
            onPressed: () {
              // Guardar estat abans de canviar el tema
              _saveState();
              ThemeService.s.toggleTheme();
            },
          ),
          
          const SizedBox(height: 8),
          
          // Comptador
          LdLabel(
            pLabel: L.sCounter,
            pPosArgs: [(_persistentState[mfCounter] ?? 0).toString()],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
    
    // Guardar referència per a manipulació programàtica
    _foldableContainers["basic"] = container;
    
    return container;
  }
  
  /// Construeix la secció de components d'entrada
  Widget _buildInputComponentsSection(BuildContext context) {
    // Recuperar el text guardat si existeix
    final savedText = _persistentState['saved_text_field_value'] as String? ?? "";
    
    final container = LdFoldableContainer(
      pTag: "InputComponentsContainer",
      titleKey: "Components d'Entrada",
      subtitleKey: "TextField, Checkbox, etc.",
      headerBackgroundColor: Theme.of(context).colorScheme.primary.setOpacity(0.1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // LdTextField
          LdTextField(
            pTag: "TestTextField",
            initialText: savedText,
            label: L.sTextField,
            helpText: L.sTextFieldHelp,
            onTextChanged: (newText) {
              // Actualitzar directament l'estat persistent
              _persistentState['saved_text_field_value'] = newText;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Mostrar el valor desat
          Text("Text desat: \"$savedText\""),
          
          const SizedBox(height: 16),
          
          // Aquí s'afegiran més components d'entrada en el futur
          const Text("Més components d'entrada en desenvolupament..."),
        ],
      ),
    );
    
    // Guardar referència per a manipulació programàtica
    _foldableContainers["input"] = container;
    
    return container;
  }
  
  /// Construeix la secció de components de temes
  Widget _buildThemeComponentsSection(BuildContext context) {
    final container = LdFoldableContainer(
      pTag: "ThemeComponentsContainer",
      titleKey: "Components de Tema",
      subtitleKey: "ThemeSelector, ThemeViewer, etc.",
      headerBackgroundColor: Theme.of(context).colorScheme.secondary.setOpacity(0.1),
      initialExpanded: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Aquí s'integraran els components de tema
          const Text("Components de tema en desenvolupament..."),
        ],
      ),
    );
    
    // Guardar referència per a manipulació programàtica
    _foldableContainers["theme"] = container;
    
    return container;
  }
  
  /// Construeix la secció de components avançats
  Widget _buildAdvancedComponentsSection(BuildContext context) {
    final container = LdFoldableContainer(
      pTag: "AdvancedComponentsContainer",
      titleKey: "Components Avançats",
      subtitleKey: "Lists, Messages, etc.",
      headerBackgroundColor: Theme.of(context).colorScheme.error.setOpacity(0.1),
      initialExpanded: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Aquí s'integraran els components avançats
          const Text("Components avançats en desenvolupament..."),
        ],
      ),
    );
    
    // Guardar referència per a manipulació programàtica
    _foldableContainers["advanced"] = container;
    
    return container;
  }
  
  /// Construeix la secció de demostració de LdFoldableContainer
  Widget _buildFoldableContainerDemoSection(BuildContext context) {
    // Diferents estils de contenidors plegables per mostrar la flexibilitat
    return LdFoldableContainer(
      pTag: "FoldableContainerDemoContainer",
      titleKey: "Demo de Contenidors Plegables",
      subtitleKey: "Diferents estils i configuracions",
      headerBackgroundColor: Colors.purple.setOpacity(0.2),
      initialExpanded: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Aquí anirien diferents exemples de contenidors
          const Text("Exemples de contenidors en desenvolupament..."),
        ],
      ),
    );
  }
  
  /// Canvia l'estat d'expansió de tots els contenidors
  void _toggleAllContainers() {
    // Per a cada contenidor registrat, alterna l'estat d'expansió
    for (final container in _foldableContainers.values) {
      container.toggle();
    }
  }
}