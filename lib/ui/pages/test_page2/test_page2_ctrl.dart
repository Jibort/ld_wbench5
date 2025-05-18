// lib/ui/pages/test_page2/test_page2_ctrl.dart
// Controlador de la pàgina de proves 2
// Created: 2025/05/17 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_ctrl_abs.dart';
import 'package:ld_wbench5/core/extensions/color_extensions.dart';
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

/// Controlador per a la pàgina de proves 2
class TestPage2Ctrl extends LdPageCtrlAbs<TestPage2> {
  // MEMBRES ==============================================
  /// Referència a contenidors plegables per a manipulació programàtica
  final Map<String, LdFoldableContainer> _foldableContainers = {};
  
  // CONSTRUCTORS/DESTRUCTORS ============================
  /// Constructor
  TestPage2Ctrl({super.pTag, required super.pPage});

  @override
  void initialize() {
    // Crear el model de la pàgina
    final config = cPage.config;
    final titleKey = config[cfTitleKey] as String? ?? config[mfTitle] as String? ?? L.sAppSabina;
    final subTitleKey = config[cfSubTitleKey] as String? ?? config[mfSubTitle] as String?;
    
    model = TestPage2Model(
      pPage: cPage,
      pTitleKey: titleKey,
      pSubTitleKey: subTitleKey,
    );
  }
  
  @override
  void update() {
    // Actualitzar estat si és necessari
    // Per ara només actualitzem l'UI, sense cap lògica addicional
    if (mounted) {
      setState(() {
        // Reconstruïm l'UI
      });
    }
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onEvent(LdEvent pEvent) {
    // Gestionar diferents tipus d'events
    if (pEvent.eType == EventType.languageChanged || 
        pEvent.eType == EventType.rebuildUI) {
      
      // Només reconstruir si està muntat
      if (mounted) {
        setState(() {
          // Forçem reconstrucció de l'UI
        });
      }
    }
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    // Executar l'actualització sempre
    pfUpdate();
    
    // Reconstruir si està muntat
    if (mounted) {
      setState(() {
        // Reconstruïm el widget
      });
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    final pageModel = model as TestPage2Model?;
    if (pageModel == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contenidor dels components bàsics
              _buildBasicComponentsSection(context),
              
              const SizedBox(height: 16),
              
              // Contenidor dels components d'entrada i formularis
              _buildInputComponentsSection(context),
              
              const SizedBox(height: 16),
              
              // Contenidor dels components de temes i estils
              _buildThemeComponentsSection(context),
              
              const SizedBox(height: 16),
              
              // Contenidor dels components avançats
              _buildAdvancedComponentsSection(context),
              
              const SizedBox(height: 16),
              
              // Contenidor per a configuracions de LdFoldableContainer
              _buildFoldableContainerDemoSection(context),
              
              const SizedBox(height: 16),
              
              // Botó per expandir/contreure tots els contenidors
              LdButton(
                text: "Toggle All Containers",
                onPressed: _toggleAllContainers,
              ),
              
              // Espai extra al final per assegurar que hi ha suficient espai 
              // quan el teclat està visible
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          (model as TestPage2Model?)?.incrementCounter();
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
            onPressed: () => L.toggleLanguage(),
          ),
          
          const SizedBox(height: 8),
          
          // LdButton amb tema diferent
          LdButton(
            text: L.sChangeTheme,
            onPressed: () => ThemeService.s.toggleTheme(),
          ),
          
          const SizedBox(height: 8),
          
          // Comptador
          LdLabel(
            pLabel: L.sCounter,
            pPosArgs: [(model as TestPage2Model?)?.counter.toString() ?? "0"],
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
    final container = LdFoldableContainer(
      pTag: "InputComponentsContainer",
      titleKey: "Components d'Entrada",
      subtitleKey: "TextField, Checkbox, etc.",
      headerBackgroundColor: Theme.of(context).colorScheme.primary.setOpacity(0.1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LdTextField
          LdTextField(
            label: L.sTextField,
            helpText: L.sTextFieldHelp,
          ),
          
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
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estil personalitzat 1: sense vora
          LdFoldableContainer(
            pTag: "CustomStyle1",
            titleKey: "Estil Sense Vora",
            subtitleKey: "Amb text i icones personalitzats",
            showBorder: false,
            headerBackgroundColor: Theme.of(context).colorScheme.primary.setOpacity(0.1),
            expansionIcon: Icons.keyboard_arrow_up,
            collapsedIcon: Icons.keyboard_arrow_down,
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Aquest contenidor no té vora i utilitza icones personalitzades per a l'expansió."),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Estil personalitzat 2: vora arrodonida
          LdFoldableContainer(
            pTag: "CustomStyle2",
            titleKey: "Estil Amb Vora Arrodonida",
            borderRadius: 16.0,
            borderColor: Colors.orange,
            borderWidth: 2.0,
            headerBackgroundColor: Colors.orange.setOpacity(0.1),
            contentBackgroundColor: Colors.orange.setOpacity(0.05),
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Aquest contenidor té una vora arrodonida amb color personalitzat."),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Estil personalitzat 3: amb accions a la capçalera
          LdFoldableContainer(
            pTag: "CustomStyle3",
            titleKey: "Amb Accions a la Capçalera",
            headerBackgroundColor: Colors.blue.setOpacity(0.1),
            headerActions: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  // Executar acció quan es premi el botó
                },
                splashRadius: 20,
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  // Executar acció quan es premi el botó
                },
                splashRadius: 20,
              ),
            ],
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Aquest contenidor té botons d'acció a la capçalera."),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Estil personalitzat 4: amb capçalera personalitzada
          LdFoldableContainer(
            pTag: "CustomStyle4",
            header: Container(
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.green.setOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                border: Border.all(color: Colors.green, width: 1.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.green),
                  const SizedBox(width: 8.0),
                  const Expanded(
                    child: Text(
                      "Capçalera Totalment Personalitzada",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: () {
                      // Acció del botó personalitzada
                    },
                  ),
                ],
              ),
            ),
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Aquest contenidor té una capçalera completament personalitzada."),
            ),
          ),
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