// lib/ui/widgets/ld_foldable_container/ld_foldable_container_ctrl.dart
// Controlador del widget LdFoldableContainer
// Created: 2025/05/17 ds. CLA
// Updated: 2025/05/17 ds. GEM - Implementació inicial del controlador.
// Updated: 2025/05/18 ds. GEM - Gestió de l'estat expandit/col·lapsat i animació.
// Updated: 2025/05/18 ds. GEM - Implementació de persistència d'estat amb mapa estàtic.
// Updated: 2025/05/18 ds. GEM - Restauració de focus després d'expandir.
// Updated: 2025/05/18 ds. GEM - Correcció de WidgetStateProperty.resolveWith i colors.
// Updated: 2025/05/18 ds. GEM - Implementació de AutomaticKeepAliveClientMixin i logs per a depuració de scroll.
// Updated: 2025/05/19 dg. CLA - Correcció de dependències i implementació de persistència centralitzada
// Updated: 2025/05/20 dl. CLA - Correcció d'implementació de AutomaticKeepAliveClientMixin

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';
import 'package:ld_wbench5/services/state_persistance_service.dart';
import 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdFoldableContainer.
/// Gestiona l'estat expandit/col·lapsat, l'animació i la interacció.
/// Utilitza AutomaticKeepAliveClientMixin per preservar l'estat en ListViews.
class LdFoldableContainerCtrl extends LdWidgetCtrlAbs<LdFoldableContainer> with AutomaticKeepAliveClientMixin {

  // MEMBRES ==============================================
  /// Duració de l'animació d'expansió.
  Duration _animationDuration = const Duration(milliseconds: 300);
  /// Node de focus que podria necessitar ser restaurat.
  FocusNode? _lastFocusedNode;

  /// Indica si el contingut està expandit (llegint directament del model).
  bool get isExpanded => (model as LdFoldableContainerModel?)?.isExpanded ?? true; // Ús segur amb ??

  /// Accés ràpid al model amb tipus segur.
  LdFoldableContainerModel? get containerModel => model as LdFoldableContainerModel?;

  /// Determina si el mixin AutomaticKeepAliveClientMixin ha de mantenir l'estat del widget
  @override
  bool get wantKeepAlive => true;

  // CONSTRUCTORS/DESTRUCTORS ============================
  /// Constructor.
  LdFoldableContainerCtrl(super.pWidget);

  @override
  void initState() {
    // IMPORTANT: Sempre cridar super.initState() PRIMER per al mixin
    super.initState();
    Debug.info("$tag: initState");
    
    // Inicialitzar el model i altres tasques
    initialize();
    
    // No cal cridar updateKeepAlive() aquí, es cridarà automàticament
    // quan canviï el valor de wantKeepAlive
  }

  /// Implementació del mètode initialize de LdLifecycleIntf
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador.");
    
    // Obtenir la duració de l'animació o establir valor per defecte
    // Fer-ho només una vegada
    _animationDuration = widget.config[cfAnimationDuration] as Duration?
          ?? const Duration(milliseconds: 300);

    _createModel(); // Crear o restaurar el model amb estat persistent.
  }

  /// Crea o restaura el model del contenidor plegable.
  void _createModel() {
    Debug.info("$tag: Creant/Restaurant model del contenidor plegable.");
    try {
      final persistentKey = StatePersistenceService.makeKey(tag, mfIsExpanded);
      final savedExpandedState = StatePersistenceService.s.getValue<bool>(persistentKey);
      
      // Prioritzar aquest ordre específic
      final initialExpanded = savedExpandedState ?? 
        (widget.config[cfInitialExpanded] as bool? ?? true);

      // Construir el mapa mínim necessari per al model
      MapDyns modelConfig = MapDyns();
      modelConfig[cfTag] = tag; // Sempre incloure el tag
      modelConfig[mfIsExpanded] = initialExpanded; // Estat inicial (mf) - Usem el valor resolt (persistent o config)

      // Afegir altres cf/mf rellevants de la configuració del widget si existeixen
      if (widget.config.containsKey(mfTitleKey)) modelConfig[mfTitleKey] = widget.config[mfTitleKey];
      if (widget.config.containsKey(mfSubtitleKey)) modelConfig[mfSubtitleKey] = widget.config[mfSubtitleKey];

      // Crear el model a partir del mapa.
      model = LdFoldableContainerModel.fromMap(modelConfig);
      Debug.info("$tag: Model creat/restaurat amb èxit. isExpanded: ${containerModel?.isExpanded}");

      // Actualitzar l'estat persistent en la primera creació si no existia
      if (savedExpandedState == null) {
        StatePersistenceService.s.setValue(persistentKey, initialExpanded);
        Debug.info("$tag: Estat inicial de persistència '$persistentKey' establert a $initialExpanded.");
      }

    } catch (e) {
      // Si hi ha un error (p.ex., configuració invàlida), crear un model de recanvi amb valors per defecte.
      Debug.error("$tag: Error creant model des de config: $e. Creant model de recanvi.");
      try {
        MapDyns fallbackConfig = MapDyns();
        fallbackConfig[cfTag] = tag;
        fallbackConfig[mfIsExpanded] = false; // Estat per defecte false
        model = LdFoldableContainerModel.fromMap(fallbackConfig);
        Debug.warn("$tag: Model de recanvi creat amb èxit.");
        // Actualitzar l'estat persistent per al model de recanvi
        StatePersistenceService.s.setValue(StatePersistenceService.makeKey(tag, mfIsExpanded), false);
      } catch (e2) {
        Debug.fatal("$tag: Error fatal creant model de recanvi: $e2"); // Si inclús el fallback falla, és fatal.
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Debug.info("$tag: didChangeDependencies");
    // Aquest mètode es crida quan canvien les dependències (com el tema).
    // Podríem actualitzar alguna cosa aquí si fos necessari basant-nos en el context,
    // però amb el patró Observer i la reconstrucció de buildContent ja n'hi hauria d'haver prou.
    update(); // Crida al mètode update() definit a LdWidgetCtrlAbs
  }

  @override
  void didUpdateWidget(covariant LdFoldableContainer oldWidget) {
     super.didUpdateWidget(oldWidget);
     Debug.info("$tag: didUpdateWidget");
     // Aquest mètode es crida quan el widget associat canvia (p.ex., els paràmetres del constructor).
     // Podríem comparar oldWidget i widget per veure si alguna configuració ha canviat i
     // actualitzar el model o l'estat intern si calgués.
     // La gestió base a LdWidgetCtrlAbs ja carrega la configuració (cf*).
     _createModel(); // Re-creem/actualitzem el model si la configuració ha canviat.
     // No necessitem cridar updateKeepAlive() aquí, es cridarà automàticament
     // quan canviï el valor de wantKeepAlive
  }

  @override
  void update() {
    // Aquest mètode es crida a didChangeDependencies i potencialment altres llocs.
    // Utilitzem-lo per realitzar actualitzacions del controlador que no requereixen reconstrucció total.
    Debug.info("$tag: Executant update().");
     // En aquest cas, no hi ha lògica d'actualització específica necessària.
  }

  @override
  void onEvent(LdEvent event) {
    // Aquest mètode es crida quan un event de l'EventBus arriba al controlador.
    Debug.info("$tag: Rebut event ${event.eType.name}.");
    if (event.eType == EventType.languageChanged || event.eType == EventType.themeChanged || event.eType == EventType.rebuildUI) {
      // Els canvis d'idioma, tema o la reconstrucció global forcen la reconstrucció del widget.
       Debug.info("$tag: Processant event ${event.eType.name}. Forçant reconstrucció via setState.");
      if (mounted) {
        setState(() {
           // La reconstrucció (buildContent) s'encarregarà de reflectir els canvis de tema/idioma.
        });
      }
    }
     // Gestionar altres events personalitzats si calgués.
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    // Aquest mètode es crida quan el model associat (LdFoldableContainerModel) canvia.
    Debug.info("$tag: Model del contenidor ha canviat. Executant actualització de UI.");
    pfnUpdate(); // Executa la funció d'actualització proporcionada (normalment setState a la base)

    // No fa falta cridar a setState explícitament aquí després de pfnUpdate() si la base ja ho fa.
    // if (mounted) { setState(() {}); }
  }

  // FUNCIONALITAT D'INTERACCIÓ ==========================
  /// Estableix l'estat d'expansió del contenidor i actualitza l'estat persistent.
  void setExpanded(bool expanded) {
    final model = containerModel;
    if (model != null && model.isExpanded != expanded) {
      Debug.info("$tag: setExpanded($expanded).");
      // Guardar l'estat del focus actual abans del canvi
      final currentFocus = FocusManager.instance.primaryFocus;
      if (currentFocus != null) {
        _lastFocusedNode = currentFocus;
        Debug.info("$tag: Focus guardat: ${_lastFocusedNode?.runtimeType}");
      }

      // Canviar l'estat d'expansió del model. Això notifica al controlador via onModelChanged.
      model.isExpanded = expanded;

      // Actualitzar l'estat persistent del contenidor al servei de persistència
      final persistentKey = StatePersistenceService.makeKey(tag, mfIsExpanded);
      StatePersistenceService.s.setValue(persistentKey, expanded);
      Debug.info("$tag: Estat persistent '$persistentKey' actualitzat a $expanded.");


      // Si estem expandint, restaurar focus després d'un retard per permetre que la UI es reconstrueixi.
      if (expanded && _lastFocusedNode != null) {
        Future.delayed(_animationDuration, () {
          if (mounted && _lastFocusedNode != null && _lastFocusedNode!.canRequestFocus) {
            _lastFocusedNode!.requestFocus();
            Debug.info("$tag: Focus restaurat.");
            _lastFocusedNode = null; // Netejar la referència un cop restaurat
          } else {
             Debug.warn("$tag: No s'ha pogut restaurar el focus.");
          }
        });
      } else if (!expanded) {
         // Si estem col·lapsant, netejar el focus si està dins d'aquest contenidor
         if (currentFocus != null && 
            currentFocus.context != null && 
            currentFocus.context!.findAncestorStateOfType<State<LdFoldableContainer>>() == this) {
            currentFocus.unfocus();
            Debug.info("$tag: Focus dins del contenidor col·lapsat. Eliminant focus.");
         }
          _lastFocusedNode = null; // Netejar referència quan col·lapsem
      }

      // Cridar el callback onExpansionChanged si existeix.
      final onExpansionChangedCallback = widget.config[efOnExpansionChanged] as Function(bool)?;
      if (onExpansionChangedCallback != null) {
        onExpansionChangedCallback(expanded);
        Debug.info("$tag: Executant callback onExpansionChanged amb estat $expanded.");
      }
    } else {
       Debug.info("$tag: setExpanded($expanded) cridat, però l'estat ja és $expanded. No fem res.");
    }
  }

  /// Alterna l'estat d'expansió del contenidor.
  void toggleExpanded() {
    Debug.info("$tag: Alternant estat d'expansió.");
    setExpanded(!isExpanded);
  }

  /// Gestió de la pressió a la capçalera.
  void _handleHeaderTap() {
    Debug.info("$tag: Capçalera del contenidor premuda.");
    // Si la interacció està habilitada, alternar l'estat
    if (widget.config[cfEnableInteraction] as bool? ?? true) {
      toggleExpanded();
    }

    // Cridar el callback onHeaderTap si existeix.
    final onHeaderTapCallback = widget.config[efOnHeaderTap] as VoidCallback?;
    if (onHeaderTapCallback != null) {
      onHeaderTapCallback();
       Debug.info("$tag: Executant callback onHeaderTap.");
    }
  }


  // CONSTRUCCIÓ DEL WIDGET VISUAL =========================
  @override
  Widget build(BuildContext context) {
    // IMPORTANT: Cridar super.build(context) per a què el mixin AutomaticKeepAliveClientMixin funcioni correctament
    super.build(context);
    
    // Delegar la construcció del contingut al mètode buildContent
    return buildContent(context);
  }
  
  @override
  Widget buildContent(BuildContext context) {
    Debug.info("$tag: Construint contingut. isVisible=$isVisible, isEnabled=$isEnabled, isExpanded=${containerModel?.isExpanded}.");

    final config = widget.config;
    final model = containerModel; // Usem el getter segur

    // Si no hi ha model, mostrar contenidor buit o recuperar-lo (la recuperació es fa en _createModel)
    if (model == null) {
      Debug.warn("$tag: Model no disponible. Mostrant contenidor de recanvi.");
      return Container(
        height: 50,
        width: double.infinity,
        color: Colors.red.withOpacity(0.3), // Color per a depuració visualment clara
        child: const Center(child: Text("Error: Model no carregat", textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
      );
    }

    // Obtenir el tema actual
    final theme = Theme.of(context);

    // Obtenir configuració de la UI
    final headerHeight = config[cfHeaderHeight] as double? ?? 56.0;
    final headerBackgroundColor = config[cfHeaderBackgroundColor] as Color? ?? theme.colorScheme.surface;
    final contentBackgroundColor = config[cfContentBackgroundColor] as Color? ?? theme.colorScheme.surface;
    final headerActions = config[cfHeaderActions] as List<Widget>? ?? [];
    final titleStyle = config[cfTitleStyle] as TextStyle? ?? theme.textTheme.titleMedium;
    final subtitleStyle = config[cfSubtitleStyle] as TextStyle? ?? theme.textTheme.bodySmall;
    final borderRadius = config[cfBorderRadius] as double? ?? 8.0;
    final borderColor = config[cfBorderColor] as Color? ?? theme.dividerColor;
    final borderWidth = config[cfBorderWidth] as double? ?? 1.0;
    final showBorder = config[cfShowBorder] as bool? ?? true;
    final expansionIcon = config[cfExpansionIcon] as IconData? ?? Icons.expand_less;
    final collapsedIcon = config[cfCollapsedIcon] as IconData? ?? Icons.expand_more;
    final headerPadding = config[cfHeaderPadding] as EdgeInsetsGeometry? ?? const EdgeInsets.symmetric(horizontal: 16.0);
    final contentPadding = config[cfContentPadding] as EdgeInsetsGeometry? ?? const EdgeInsets.all(16.0);


    // Widget capçalera personalitzada o capçalera per defecte
    final headerWidget = config[cfHeader] as Widget?;

    // Construir la capçalera
    final header = headerWidget ??
        GestureDetector(
          onTap: _handleHeaderTap,
          behavior: HitTestBehavior.opaque, // Permet detectar taps a l'àrea transparent del contenidor
          child: Container(
            height: headerHeight,
            decoration: BoxDecoration(
              color: headerBackgroundColor,
              borderRadius: showBorder
                  ? BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(model.isExpanded ? 0 : borderRadius), // Bordes rodons a sota només quan està col·lapsat
                      bottomRight: Radius.circular(model.isExpanded ? 0 : borderRadius),
                    )
                  : null,
              border: showBorder ? Border.all(
                      color: borderColor,
                      width: borderWidth,
                    )
                  : null,
            ),
            padding: headerPadding,
            child: Row(
              children: [
                // Espai per a títol i subtítol
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Títol
                      if (model.titleKey != null)
                        Text(
                          model.titleKey!.tx(), // Obtenim el títol traduït del model
                          style: titleStyle,
                          overflow: TextOverflow.ellipsis, // Evitar desbordament
                        ),
                      // Subtítol
                      if (model.subtitleKey != null)
                        Text(
                          model.subtitleKey!.tx(), // Obtenim el subtítol traduït del model
                          style: subtitleStyle,
                          overflow: TextOverflow.ellipsis, // Evitar desbordament
                        ),
                    ],
                  ),
                ),
                // Accions de la capçalera
                ...headerActions,
                // Botó d'expansió
                IconButton(
                  icon: Icon(model.isExpanded ? expansionIcon : collapsedIcon),
                  onPressed: () => toggleExpanded(), // Alternar estat al prémer la icona
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(), // Eliminar padding/tamany mínim
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        );

    // Widget contingut
    final contentWidget = config[cfContent] as Widget? ?? const SizedBox.shrink();

    // Construir el contenidor amb animació
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupar tot l'ample disponible
      children: [
        // Capçalera (sempre visible)
        header,
        // Contingut (amb animació d'altura)
        AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          // Altura: 0 quan col·lapsat, o altura automàtica quan expandit.
          // Usem una altura finita (double.infinity) amb SingleChildScrollView per evitar errors
          // 'unbounded constraints' amb AnimatedContainer.
          height: model.isExpanded ? null : 0.0, // Usem null per altura automàtica quan expandit

          clipBehavior: Clip.antiAlias, // Retallar contingut que desbordi durant l'animació
          decoration: BoxDecoration(
            color: contentBackgroundColor,
            borderRadius: showBorder
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius),
                  )
                : null,
            border: showBorder
                ? Border(
                    left: BorderSide(color: borderColor, width: borderWidth),
                    right: BorderSide(color: borderColor, width: borderWidth),
                    bottom: BorderSide(color: borderColor, width: borderWidth), // Borde a la part inferior del contingut
                  )
                : null,
          ),
          // Usem Visibility per controlar la visibilitat del contingut sense descartar l'arbre de widgets
          child: Visibility(
            visible: model.isExpanded, // Visible si està expandit
            maintainState: true, // Mantenim l'estat dels widgets interns
            maintainAnimation: true, // Mantenim les animacions dels widgets interns
            maintainSize: false, // No reservem espai quan no és visible (les animacions manegen l'altura)
            child: SingleChildScrollView( // Afegir scroll al contingut per evitar desbordament si és molt gran
              physics: model.isExpanded ? null : const NeverScrollableScrollPhysics(), // Deshabilitar scroll quan està col·lapsat
              child: Padding(
                padding: contentPadding,
                child: contentWidget, // El widget de contingut proporcionat al constructor
              ),
            ),
          ),
        ),
      ],
    );
  }
}