// lib/ui/pages/test_page2/test_page2_ctrl.dart
// Controlador de la pàgina de proves 2
// Created: 2025/05/17 ds. CLA
// Updated: 2025/05/18 ds. GEM - Correcció de persistència d'estat per LdFoldableContainer
// Updated: 2025/05/18 ds. GEM - Desbloqueig de totes les seccions de contenidors
// Updated: 2025/05/18 ds. GEM - Inclusió del contenidor demo al mapa _foldableContainers
// Updated: 2025/05/18 ds. GEM - Inclusió de prova de folders anidats amb persistència
// Updated: 2025/05/18 ds. GEM - Correcció de la interpolació de Strings
// Updated: 2025/05/18 ds. GEM - Referència a la clau de traducció del botó Toggle All amb L.s... i logs de depuració.

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
    Debug.info("$tag: Inicialitzant controlador");
    final config = cPage.config;
    final titleKey = config[cfTitleKey] as String? ?? config[mfTitle] as String? ?? L.sAppSabina;
    final subTitleKey = config[cfSubTitleKey] as String? ??
        config[mfSubTitle] as String?;

    // -- GESTIÓ DE L'ESTAT PERSISTENT INICIAL --
    // Si l'estat persistent està buit, és la primera inicialització.
    // Inicialitzem l'estat amb els valors per defecte del model de pàgina
    // i els estats inicials DESITJATS per als components individuals.
    if (_persistentState.isEmpty) {
      Debug.info("$tag: Estat persistent buit. Inicialitzant amb valors per defecte.");
      model = TestPage2Model(
        pPage: cPage,
        pTitleKey: titleKey,
        pSubTitleKey: subTitleKey,
      );
      // Inicialitzar valors per defecte per a components individuals
      // Aquests seran els valors usats si no hi ha estat guardat
      _persistentState['saved_text_field_value'] = ""; // Estat del TextField
      _persistentState[mfCounter] = 0; // Estat del Comptador al model de pàgina
      // Estats per defecte dels contenidors plegables (primer nivell)
      _persistentState["BasicComponentsContainer_$mfIsExpanded"] = true;
      _persistentState["InputComponentsContainer_$mfIsExpanded"] = true;
      _persistentState["ThemeComponentsContainer_$mfIsExpanded"] = false;
      _persistentState["AdvancedComponentsContainer_$mfIsExpanded"] = false;
      _persistentState["FoldableContainerDemoContainer_$mfIsExpanded"] = false;
      // Estats per defecte dels contenidors anidats (prova)
      _persistentState["NestedContainerExample1_$mfIsExpanded"] = true;
      _persistentState["NestedContainerExample2_$mfIsExpanded"] = false;


    } else {
      // Si l'estat persistent NO està buit, intentem restaurar el model de pàgina
      // des d'aquest estat. Els estats dels components individuals ja resideixen
      // al mapa i seran llegits directament en els mètodes _build...Section.
      Debug.info("$tag: Estat persistent trobat. Intentant restaurar model de pàgina.");
      try {
        model = TestPage2Model.fromMap(cPage, _persistentState);
        // Si la restauració del model de pàgina falla per algun motiu,
        // catch l'inicialitzarà de nou i ja haurem perdut els seus valors,
        // però l'estat dels components individuals al mapa _persistentState
        // hauria de romandre intacte.
      } catch (e) {
        Debug.error("$tag: Error restaurant model de pàgina des d'estat persistent: $e. Creant nou model de pàgina.");
        model = TestPage2Model(
          pPage: cPage,
          pTitleKey: titleKey,
          pSubTitleKey: subTitleKey,
        );
        // Opcionalment, si es detecta un error greu de consistència,
        // es podria considerar reiniciar _persistentState, però per ara
        // suposem que els valors individuals són robustos.
        // _persistentState.clear(); // Perillós, esborraria tot l'estat guardat
      }
       // Assegurem que les claus dels nous contenidors (primer nivell i anidats)
       // existeixen a l'estat persistent si ja hi havia estat guardat previ.
       // Això gestiona l'addició de nous components a la pàgina després de la primera execució.
       _persistentState.putIfAbsent("BasicComponentsContainer_$mfIsExpanded", () => true);
       _persistentState.putIfAbsent("InputComponentsContainer_$mfIsExpanded", () => true);
       _persistentState.putIfAbsent("ThemeComponentsContainer_$mfIsExpanded", () => false);
       _persistentState.putIfAbsent("AdvancedComponentsContainer_$mfIsExpanded", () => false);
       _persistentState.putIfAbsent("FoldableContainerDemoContainer_$mfIsExpanded", () => false);
       _persistentState.putIfAbsent("NestedContainerExample1_$mfIsExpanded", () => true);
       _persistentState.putIfAbsent("NestedContainerExample2_$mfIsExpanded", () => false);


    }
     Debug.info("$tag: Inicialització completada. Estat persistent actual: $_persistentState");
  }

  @override
  void update() {
    // Aquest mètode es crida a didChangeDependencies.
    // Podem forçar una reconstrucció si calgués per dependències externes,
    // però amb la gestió d'esdeveniments i l'observació del model ja n'hi hauria d'haver prou.
    // setState(() {}); // Normalment no cal aquí si l'observador del model crida setState
  }

  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos del controlador de pàgina.");
    // Desenregistrar observadors si n'hi hagués de TimeService, etc.
    // (Afegir aquí la lògica específica si es subscriu a altres models)

    // El model de pàgina es desenregistra automàticament a super.dispose()
    // ja que el controlador és un observador del model.
    // No cal guardar l'estat aquí explícitament si onModelChanged ja ho fa.
    // Només si dispose es crida sense un canvi de model previ podria caldre.
    // Per seguretat, ho podem mantenir, però cal ser conscients del cicle.
    _saveState(); // Guarda l'estat final al tancar la pàgina

    super.dispose();
     Debug.info("$tag: Recursos del controlador de pàgina alliberats.");
  }

  /// Guarda l'estat actual (només els camps del model de pàgina) per a futures reconstruccions.
  /// L'estat dels components individuals (contenidors, textfield) s'actualitza
  /// directament al mapa _persistentState quan els seus propis estats canvien.
  void _saveState() {
    final currentModel = model as TestPage2Model?;
    if (currentModel != null) {
      // Convertir el model de PÀGINA a un mapa.
      final modelMap = currentModel.toMap();

      // Actualitzar només els camps del model de PÀGINA que volem persistir.
      // Assegurem que només actualitzem les claus conegudes per al model de pàgina
      // i no toquem els estats dels components individuals guardats amb les seves claus.
       _persistentState[mfTitle] = modelMap[mfTitle]; // Actualitzar títol
       _persistentState[mfSubTitle] = modelMap[mfSubTitle]; // Actualitzar subtítol
       _persistentState[mfCounter] = modelMap[mfCounter]; // Actualitzar comptador
       _persistentState[mfTag] = modelMap[mfTag]; // Actualitzar tag del model

      Debug.info("$tag: Estat del model de pàgina desat (títol, subtítol, comptador, tag) per a persistència. Estat complet: $_persistentState");
    } else {
       Debug.warn("$tag: Intent de guardar estat del model de pàgina, però el model és null.");
    }
  }


  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Event rebut: ${event.eType.name}");
    // Gestionar diferents tipus d'events que requereixen reconstrucció global
    if (event.eType == EventType.languageChanged ||
        event.eType == EventType.themeChanged ||
        event.eType == EventType.rebuildUI) {

      Debug.info("$tag: Event ${event.eType.name} requerint reconstrucció. Guardant estat abans.");
      // Guardar l'estat de la pàgina i components abans de la reconstrucció
      _saveState(); // Guarda l'estat del model de pàgina. L'estat dels components ja està guardat.

      // Només reconstruir si està muntat
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció de la UI després de l'event ${event.eType.name}");
        });
      }
    }
     // Gestionar altres events si calgués (sen se reconstrucció global)
     // ...
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    Debug.info("$tag.onModelChanged(): Model ${pModel.tag} ha canviat.");
    // Executar l'acció d'actualització proporcionada (normalment setState a la base)
    pfnUpdate();

    // Guardar l'estat quan canvia el model de pàgina (el comptador)
    // Això assegura que el comptador persistent s'actualitza.
    if (pModel is TestPage2Model) {
       _saveState(); // Guarda l'estat del model de pàgina
    }
    // L'estat dels components individuals (contenidors) ja s'actualitza
    // directament en els seus callbacks onExpansionChanged.

    // Forçar reconstrucció si estem muntats i el canvi prové d'un model
    // que necessita actualitzar la UI (el model de pàgina o un model important)
     // NOTA: Amb Function Observers, sovint la reconstrucció ja es gestiona
     // a nivell més baix. Aquí només reconstruïm la pàgina si un canvi global
     // o del model de pàgina ho requereix. Si el model canviat és un
     // sub-model gestionat per un widget fill, potser no cal reconstruir tota la pàgina.
     // Per simplicitat i per capturar canvis al model de pàgina, mantenim aquest setState.
    if (mounted) {
      setState(() {
        Debug.info("$tag.onModelChanged(): Reconstruint widget després del canvi del model ${pModel.tag}");
      });
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    // Aquest mètode es crida cada vegada que setState es dispara al controlador de pàgina.
    // ÉS CRUCIAL que aquí construïm els widgets fills LLEGINT SEMPRE l'estat persistent
    // com a font de veritat per al seu estat inicial (excepte la primera inicialització global).

    final pageModel = model as TestPage2Model?;
    if (pageModel == null) {
       Debug.error("$tag: Model de pàgina és null durant buildPage. Mostrant indicador.");
      return const Center(child: CircularProgressIndicator());
    }

    // Netegem referències antigues als contenidors a cada build
    // Això força a obtenir noves referències als widgets/controladors recreats
    _foldableContainers.clear();

    Debug.info("$tag: Construint pàgina. Estat persistent actual: $_persistentState");


    return LdScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LdAppBar(
          pTitleKey: pageModel.title, // Títol del model de pàgina (persistent)
          pSubTitleKey: pageModel.subTitle, // Subtítol del model de pàgina (persistent)
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

            const SizedBox(height: 16),

            // Contenidor dels components de temes i estils
            _buildThemeComponentsSection(context),

            const SizedBox(height: 16),

            // Contenidor dels components avançats
            _buildAdvancedComponentsSection(context),

            const SizedBox(height: 16),

            // Contenidor per a configuracions de LdFoldableContainer (desbloquejat)
             _buildFoldableContainerDemoSection(context),

            const SizedBox(height: 16),

            // Botó per expandir/contreure tots els contenidors
            LdButton(
              text: L.sToggleAllContainers, // Utilitzem la constant de L.dart (CORRECCIÓ)
              onPressed: _toggleAllContainers, // Aquesta funció actua sobre _foldableContainers
            ),

            // Espai extra al final
            const SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (model != null) {
            Debug.info("$tag: Botó flotant premut. Incrementant comptador.");
            (model as TestPage2Model).incrementCounter(); // Això notifica als observadors i guarda l'estat via onModelChanged
          } else {
             Debug.warn("$tag: Botó flotant premut, però model de pàgina és null.");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // SECCIONS DE LA PÀGINA ================================
  /// Construeix la secció de components bàsics
  Widget _buildBasicComponentsSection(BuildContext context) {
     const containerTag = "BasicComponentsContainer";
     // -- LLEGIR L'ESTAT PERSISTENT --
     // Prioritzem l'estat guardat. Si no existeix, usem el valor per defecte codificat.
     final initialExpanded = _persistentState["${containerTag}_$mfIsExpanded"] as bool?
                              ?? true; // Valor per defecte si no hi ha estat guardat


    final container = LdFoldableContainer(
      pTag: containerTag,
      titleKey: "##sBasicComponents", // Utilitzem clau de traducció
      subtitleKey: "##sBasicComponentsSubtitle", // Utilitzem clau de traducció
      initialExpanded: initialExpanded, // <--- UTILITZEM SEMPRE L'ESTAT LLEGIT
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
              // Guardar estat de la pàgina/TextField/Counter (els contenidors ja són persistents)
              _saveState();
              // El canvi d'idioma emet un esdeveniment que provoca una reconstrucció
              // La nova construcció llegirà l'estat persistent correctament
              L.toggleLanguage();
            },
          ),

          const SizedBox(height: 8),

          // LdButton amb tema diferent
          LdButton(
            text: L.sChangeTheme,
            onPressed: () {
              // Guardar estat de la pàgina/TextField/Counter (els contenidors ja són persistents)
               _saveState();
              // El canvi de tema emet un esdeveniment que provoca una reconstrucció
              // La nova construcció llegirà l'estat persistent correctament
              ThemeService.s.toggleTheme();
            },
          ),

          const SizedBox(height: 8),

          // Comptador (el seu valor es persistent via _persistentState[mfCounter])
          LdLabel(
            pLabel: L.sCounter,
            pPosArgs: [(_persistentState[mfCounter] ?? 0).toString()],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
       // -- ACTUALITZAR L'ESTAT PERSISTENT QUAN CANVIA --
       onExpansionChanged: (expanded) {
         Debug.info("$tag: Estat d'expansió de $containerTag canviat a $expanded via UI.");
         _persistentState["${containerTag}_$mfIsExpanded"] = expanded;
         // No cal setState aquí, el canvi en el model del contenidor ja ho pot fer
         // si està ben implementat, o el setState global ja capturarà el canvi a _persistentState
       },
    );
    // Guardar referència per a manipulació programàtica (per _toggleAllContainers)
    _foldableContainers[containerTag] = container;

    return container;
  }

  /// Construeix la secció de components d'entrada
  Widget _buildInputComponentsSection(BuildContext context) {
     const containerTag = "InputComponentsContainer";
     // -- LLEGIR L'ESTAT PERSISTENT --
     final initialExpanded = _persistentState["${containerTag}_$mfIsExpanded"] as bool?
                              ?? true; // Valor per defecte si no hi ha estat guardat

    // Recuperar el text guardat si existeix
    final savedText = _persistentState['saved_text_field_value'] as String?
        ?? "";

    final container = LdFoldableContainer(
      pTag: containerTag,
      titleKey: "##sInputComponents", // Utilitzem clau de traducció
      subtitleKey: "##sInputComponentsSubtitle", // Utilitzem clau de traducció
      headerBackgroundColor: Theme.of(context).colorScheme.primary.setOpacity(0.1),
      initialExpanded: initialExpanded, // <--- UTILITZEM SEMPRE L'ESTAT LLEGIT
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // LdTextField (el seu estat de text es persistent via _persistentState['saved_text_field_value'])
          LdTextField(
            pTag: "TestTextField", // Mantenim el tag per a persistència del TextField
            initialText: savedText, // S'inicialitza des de _persistentState
            label: L.sTextField,
            helpText: L.sTextFieldHelp,
            onTextChanged: (newText) {
              // Actualitzar directament l'estat persistent del TextField
              _persistentState['saved_text_field_value'] = newText;
              Debug.info("$tag: Estat persistent del TextField actualitzat a \"$newText\".");
               // No cal setState aquí si el TextField està ben implementat
               // per notificar canvis que afectin la UI que mostra 'Text desat'.
               // Si 'Text desat' NO s'actualitza, podríem necessitar un setState aquí
               // o fer que 'Text desat' observi _persistentState.
            },
          ),

          const SizedBox(height: 16),

          // Mostrar el valor desat (aquest text no es tradueix, es per debug/visualització ràpida de l'estat persistent)
          Text("Text desat: \"${_persistentState['saved_text_field_value'] ?? ""}\""),

          const SizedBox(height: 16),

          // Aquí s'afegiran més components d'entrada en el futur
           LdLabel(
            pLabel: "##sMoreInputComponents", // Utilitzem clau de traducció
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      // -- ACTUALITZAR L'ESTAT PERSISTENT QUAN CANVIA --
       onExpansionChanged: (expanded) {
         Debug.info("$tag: Estat d'expansió de $containerTag canviat a $expanded via UI.");
         _persistentState["${containerTag}_$mfIsExpanded"] = expanded;
         // No cal setState aquí
       },
    );
    // Guardar referència per a manipulació programàtica (per _toggleAllContainers)
    _foldableContainers[containerTag] = container;

    return container;
  }

  /// Construeix la secció de components de temes
  Widget _buildThemeComponentsSection(BuildContext context) {
     const containerTag = "ThemeComponentsContainer";
     // -- LLEGIR L'ESTAT PERSISTENT --
     final initialExpanded = _persistentState["${containerTag}_$mfIsExpanded"] as bool?
                              ?? false; // Valor per defecte si no hi ha estat guardat

    final container = LdFoldableContainer(
      pTag: containerTag,
      titleKey: "##sThemeComponents", // Utilitzem clau de traducció
      subtitleKey: "##sThemeComponentsSubtitle", // Utilitzem clau de traducció
      headerBackgroundColor: Theme.of(context).colorScheme.secondary.setOpacity(0.1),
      initialExpanded: initialExpanded, // <--- UTILITZEM SEMPRE L'ESTAT LLEGIT
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Aquí s'integraran els components de tema
           LdLabel(
            pLabel: "##sThemeComponentsPlaceholder", // Utilitzem clau de traducció
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      // -- ACTUALITZAR L'ESTAT PERSISTENT QUAN CANVIA --
       onExpansionChanged: (expanded) {
         Debug.info("$tag: Estat d'expansió de $containerTag canviat a $expanded via UI.");
         _persistentState["${containerTag}_$mfIsExpanded"] = expanded;
         // No cal setState aquí
       },
    );
    // Guardar referència per a manipulació programàtica (per _toggleAllContainers)
    _foldableContainers[containerTag] = container;

    return container;
  }

  /// Construeix la secció de components avançats
  Widget _buildAdvancedComponentsSection(BuildContext context) {
     const containerTag = "AdvancedComponentsContainer";
     // -- LLEGIR L'ESTAT PERSISTENT --
     final initialExpanded = _persistentState["${containerTag}_$mfIsExpanded"] as bool?
                              ?? false; // Valor per defecte si no hi ha estat guardat

    final container = LdFoldableContainer(
      pTag: containerTag,
      titleKey: "##sAdvancedComponents", // Utilitzem clau de traducció
      subtitleKey: "##sAdvancedComponentsSubtitle", // Utilitzem clau de traducció
      headerBackgroundColor: Theme.of(context).colorScheme.error.setOpacity(0.1),
      initialExpanded: initialExpanded, // <--- UTILITZEM SEMPRE L'ESTAT LLEGIT
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Aquí s'integraran els components avançats
          LdLabel(
            pLabel: "##sAdvancedComponentsPlaceholder", // Utilitzem clau de traducció
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      // -- ACTUALITZAR L'ESTAT PERSISTENT QUAN CANVIA --
       onExpansionChanged: (expanded) {
         Debug.info("$tag: Estat d'expansió de $containerTag canviat a $expanded via UI.");
         _persistentState["${containerTag}_$mfIsExpanded"] = expanded;
         // No cal setState aquí
       },
    );
    // Guardar referència per a manipulació programàtica (per _toggleAllContainers)
    _foldableContainers[containerTag] = container;

    return container;
  }

  /// Construeix la secció de demostració de LdFoldableContainer amb contenidors anidats
  Widget _buildFoldableContainerDemoSection(BuildContext context) {
     const containerTag = "FoldableContainerDemoContainer";
     // -- LLEGIR L'ESTAT PERSISTENT DEL CONTENIDOR PARE --
     final initialExpanded = _persistentState["${containerTag}_$mfIsExpanded"] as bool?
                              ?? false; // Valor per defecte si no hi ha estat guardat

    // Diferents estils de contenidors plegables per mostrar la flexibilitat
    final container = LdFoldableContainer(
      pTag: containerTag,
      titleKey: "##sFoldableContainerDemo", // Utilitzem clau de traducció
      subtitleKey: "##sFoldableContainerDemoSubtitle", // Utilitzem clau de traducció
      headerBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh, // <-- Utilitzem un color surfaceContainer
      initialExpanded: initialExpanded, // <--- UTILITZEM SEMPRE L'ESTAT LLEGIT DEL PARE
      content: Column( // Contingut del contenidor pare
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LdLabel(
            pLabel: "##sFoldableContainerDemoPlaceholder", // Utilitzem clau de traducció
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // -- PROVA DE CONTENIDORS ANIDATS --
          // Aquests criden a _buildNestedContainer per crear-los i gestionar la seva persistència
          _buildNestedContainer(context, "NestedContainerExample1", "##sNestedContainerTitle1", "##sNestedContainerSubtitle1", "##sNestedContainerContent1"),
          const SizedBox(height: 8),
          _buildNestedContainer(context, "NestedContainerExample2", "##sNestedContainerTitle2", "##sNestedContainerSubtitle2", "##sNestedContainerContent2"),
           // Podríem afegir-ne més aquí
        ],
      ),
      // -- ACTUALITZAR L'ESTAT PERSISTENT DEL CONTENIDOR PARE QUAN CANVIA --
       onExpansionChanged: (expanded) {
         Debug.info("$tag: Estat d'expansió de $containerTag (Pare) canviat a $expanded via UI.");
         _persistentState["${containerTag}_$mfIsExpanded"] = expanded;
         // No cal setState aquí
       },
       // Nota: Els contenidors anidats NO s'afegeixen al mapa _foldableContainers
       // perquè no volem que responguin al botó "Toggle All Containers" de primer nivell,
       // només al seu propi botó d'expansió/contracció a la capçalera.
    );

    // -- AFegir el contenidor PARE al mapa _foldableContainers --
    // Aquest és el que respon al "Toggle All" de primer nivell.
    _foldableContainers[containerTag] = container;


    return container;
  }

  /// Mètode auxiliar per construir un contenidor anidat i gestionar la seva persistència
  Widget _buildNestedContainer(BuildContext context, String tag, String titleKey, String subtitleKey, String contentKey) {
     // -- LLEGIR L'ESTAT PERSISTENT DEL CONTENIDOR ANIDAT --
     final initialExpanded = _persistentState["${tag}_$mfIsExpanded"] as bool?
                              ?? false; // Valor per defecte per anidats (col·lapsats per defecte)

    final container = LdFoldableContainer(
      pTag: tag,
      titleKey: titleKey,
      subtitleKey: subtitleKey,
      headerBackgroundColor: Theme.of(context).colorScheme.surfaceContainer, // <-- Utilitzem un altre color surfaceContainer per l'anidat
      initialExpanded: initialExpanded, // <--- UTILITZEM SEMPRE L'ESTAT LLEGIT DE L'ANIDAT
      content: Padding( // Afegir padding al contingut anidat
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reduir padding lateral
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [
             LdLabel(pLabel: contentKey),
             // Podríem afegir més contingut o altres widgets aquí
           ],
        ),
      ),
       // -- ACTUALITZAR L'ESTAT PERSISTENT DEL CONTENIDOR ANIDAT QUAN CANVIA --
       onExpansionChanged: (expanded) {
         Debug.info("$tag: Estat d'expansió de $tag (Anidat) canviat a $expanded via UI.");
         _persistentState["${tag}_$mfIsExpanded"] = expanded;
         // No cal setState aquí
       },
       // Nota: Els contenidors anidats NO s'afegeixen al mapa _foldableContainers
       // perquè no volem que responguin al botó "Toggle All Containers" de primer nivell,
       // només al seu propi botó d'expansió/contracció a la capçalera.
    );

     // NOTA IMPORTANT: No afegim els contenidors anidats a _foldableContainers
     // perquè aquest mapa només és per als contenidors de primer nivell que
     // es controlen amb el botó "_toggleAllContainers".

    return container;
  }


  /// Canvia l'estat d'expansió de tots els contenidors
  void _toggleAllContainers() {
    // Per a cada contenidor registrat, alterna l'estat d'expansió
    // Aquesta acció també actualitzarà l'estat persistent via el callback onExpansionChanged
    Debug.info("$tag: Alternant estat de tots els contenidors plegables.");
    if (_foldableContainers.isEmpty) {
       Debug.warn("$tag: No hi ha contenidors registrats per alternar.");
       return;
    }

    // Determine the target state based on the first container
    // Ensure the first container actually has a controller/model before accessing isExpanded
    bool targetState = false;
    // Access through the widget instance in the map
    final firstContainer = _foldableContainers.values.first;
    if (firstContainer.containerCtrl?.isExpanded != null) {
       targetState = !firstContainer.containerCtrl!.isExpanded;
       Debug.info("$tag: Estat del primer contenidor ('${firstContainer.tag}') és ${firstContainer.containerCtrl!.isExpanded}. Estat objectiu: $targetState.");
    } else {
       // Fallback: if the first container's state is unknown, just decide based on a default (e.g., collapse all)
       Debug.warn("$tag: No s'ha pogut obtenir l'estat del primer contenidor per determinar l'estat objectiu. Col·lapsant tots per defecte.");
       targetState = false; // Default action if state is unknown
    }


    // Apply the target state to all containers in the map
    for (var container in _foldableContainers.values) {
       Debug.info("$tag: Aplicant estat objectiu ($targetState) al contenidor '${container.tag}'.");
       container.setExpanded(targetState);
       // Persistence is updated via the onExpansionChanged callback of each container
    }
     // NOTA: L'estat d'expansió dels contenidors anidats NO es controla amb aquest botó,
     // només els contenidors de primer nivell al mapa _foldableContainers.
  }
}