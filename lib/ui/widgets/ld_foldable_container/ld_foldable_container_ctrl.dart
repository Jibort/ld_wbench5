// lib/ui/widgets/ld_foldable_container/ld_foldable_container_ctrl.dart
// Controlador del widget LdFoldableContainer
// Created: 2025/05/17 ds. CLA
// Updated: 2025/05/17 ds. GEM - Implementaci  inicial del controlador.
// Updated: 2025/05/18 ds. GEM - Gesti  de l'estat expandit/col·lapsat i animaci .
// Updated: 2025/05/18 ds. GEM - Implementaci  de persistència d'estat amb mapa estàtic.
// Updated: 2025/05/18 ds. GEM - Restauració de focus després d'expandir.
// Updated: 2025/05/18 ds. GEM - Correcció de WidgetStateProperty.resolveWith i colors.
// Updated: 2025/05/18 ds. GEM - Implementació de AutomaticKeepAliveClientMixin i logs per a depuració de scroll.
// Updated: 2025/05/19 dg. CLA - Correcció de dependències i implementació de persistència centralitzada

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';
import 'package:ld_wbench5/services/state_persistance_service.dart';
import 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container.dart';
import 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdFoldableContainer.
/// Gestiona l'estat expandit/col·lapsat, l'animació i la interacció.
/// Utilitza AutomaticKeepAliveClientMixin per preservar l'estat en ListViews.
class LdFoldableContainerCtrl extends LdWidgetCtrlAbs<LdFoldableContainer> with AutomaticKeepAliveClientMixin {

  // MEMBRES ==============================================
  /// Duraci  de l'animaci  d'expansi .
  late final Duration _animationDuration;
  /// Node de focus que podria necessitar ser restaurat.
  FocusNode? _lastFocusedNode;

  /// Indica si el contingut est  expandit (llegint directament del model).
  bool get isExpanded => (model as LdFoldableContainerModel?)?.isExpanded ?? true; // Ús segur amb ??

  /// Accés ràpid al model amb tipus segur.
  LdFoldableContainerModel? get containerModel => model as LdFoldableContainerModel?;


  // CONSTRUCTORS/DESTRUCTORS ============================
  /// Constructor.
  LdFoldableContainerCtrl(super.pWidget);

  @override
  void initState() {
     super.initState();
     Debug.info("$tag: initState");
  }

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador.");
    // Obtenir la duraci  de l'animaci  o establir valor per defecte
    _animationDuration = widget.config[cfAnimationDuration] as Duration?
        ?? const Duration(milliseconds: 300);

    _createModel(); // Crear o restaurar el model amb estat persistent.

    // Assegurar-se que l'estat es manté viu a ListViews
    updateKeepAlive(); // Cal cridar-ho desprós de decidir si cal KeepAlive.

     Debug.info("$tag: Inicialització completada. isExpanded: ${containerModel?.isExpanded}");
  }

  /// Crea o restaura el model do contenidor plegable.
  /// Intenta carregar l'estat inicial des del mapa de persistència global.
  void _createModel() {
    Debug.info("$tag: Creant/Restaurant model del contenidor plegable.");
    try {
      // Obtenir l'estat inicial des del servei de persistència,
      // o des de la configuració del widget com a fallback si no existeix.
      final persistentKey = StatePersistenceService.makeKey(tag, mfIsExpanded);
      final savedExpandedState = StatePersistenceService.s.getValue<bool>(persistentKey);

      // El valor initialExpanded da configuració do widget només s'usa si NO hi ha estat guardat.
      final initialExpandedFromConfig = widget.config[cfInitialExpanded] as bool? ?? true;

      // Prioritzem l'estat guardat, si existeix.
      final initialExpanded = savedExpandedState ?? initialExpandedFromConfig;

      // Construir o mapa mínim necessari per ao model
      MapDyns modelConfig = MapDyns();
      modelConfig[cfTag] = tag; // Sempre incloure o tag
      modelConfig[mfIsExpanded] = initialExpanded; // Estat inicial (mf) - Usamos o valor resolt (persistent o config)

      // Afegir outras cf/mf rellevants da configuració do widget si existen
      if (widget.config.containsKey(mfTitleKey)) modelConfig[mfTitleKey] = widget.config[mfTitleKey];
      if (widget.config.containsKey(mfSubtitleKey)) modelConfig[mfSubtitleKey] = widget.config[mfSubtitleKey];

      // Crear o modelo a partir do mapa.
      model = LdFoldableContainerModel.fromMap(modelConfig);
      Debug.info("$tag: Model creat/restaurat com éxito. isExpanded: ${containerModel?.isExpanded}");

      // Actualizar o estado persistente na primeira creación se non existia
      if (savedExpandedState == null) {
        StatePersistenceService.s.setValue(persistentKey, initialExpanded);
        Debug.info("$tag: Estat inicial de persistencia '$persistentKey' establert a $initialExpanded.");
      }

    } catch (e) {
      // Se hai un error (p.ex., configuración invàlida), crear un modelo de recanvi com valores por defecto.
      Debug.error("$tag: Error creando modelo desde config: $e. Creando modelo de recambio.");
      try {
        MapDyns fallbackConfig = MapDyns();
        fallbackConfig[cfTag] = tag;
        fallbackConfig[mfIsExpanded] = false; // Estado por defecto false
        model = LdFoldableContainerModel.fromMap(fallbackConfig);
        Debug.warn("$tag: Modelo de recambio creado com éxito.");
        // Actualizar o estado persistente para o modelo de recambio
        StatePersistenceService.s.setValue(StatePersistenceService.makeKey(tag, mfIsExpanded), false);
      } catch (e2) {
        Debug.fatal("$tag: Error fatal creando modelo de recambio: $e2"); // Se incluso o fallback falla, é fatal.
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
  void didUpdateWidget(covariant T oldWidget) {
     super.didUpdateWidget(oldWidget);
     Debug.info("$tag: didUpdateWidget");
     // Aquest mètode es crida quan el widget associat canvia (p.ex., els paràmetres del constructor).
     // Podríem comparar oldWidget i widget per veure si alguna configuració ha canviat i
     // actualitzar el model o l'estat intern si calgués.
     // La gestió base a LdWidgetCtrlAbs ja carrega la configuració (cf*).
     _createModel(); // Re-creem/actualitzem el model si la configuració ha canviat.
     updateKeepAlive(); // Assegurar que keepAlive es manté actualitzat amb el nou widget si la lògica canviés.
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
           // La reconstrucció (buildContent) s'encarregarà do reflectir els canvis de tema/idioma.
        });
      }
    }
     // Gestionar altres events personalitzats si calgués.
  }

  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    // Aquest mètode es crida quan o model associado (LdFoldableContainerModel) canvia.
    Debug.info("$tag: Model do contenidor ha canviat. Executant actualització de UI.");
    pfnUpdate(); // Executa a función de actualización proporcionada (normalmente setState na base)

    // Non fai falta chamar a setState explícitamente aquí despois de pfnUpdate() se a base xa o fai.
    // if (mounted) { setState(() {}); }
  }


  // FUNCIONALITAT D'INTERACCIÓ ==========================
  /// Establece o estado de expansión do contenedor e actualiza o estado persistente.
  void setExpanded(bool expanded) {
    final model = containerModel;
    if (model != null && model.isExpanded != expanded) {
      Debug.info("$tag: setExpanded($expanded).");
      // Gardar o estado do foco actual antes do cambio
      final currentFocus = FocusManager.instance.primaryFocus;
      if (currentFocus != null) {
        _lastFocusedNode = currentFocus;
        Debug.info("$tag: Foco gardado: ${_lastFocusedNode?.runtimeType}");
      }

      // Cambiar o estado de expansión do modelo. Isto notifica ao controlador via onModelChanged.
      model.isExpanded = expanded;

      // Actualizar o estado persistente do contenedor no mapa estático da pàgina
      final persistentKey = StatePersistenceService.makeKey(tag, mfIsExpanded);
      StatePersistenceService.s.setValue(persistentKey, expanded);
      Debug.info("$tag: Estado persistente '$persistentKey' actualizado a $expanded.");


      // Se estamos expandindo, restaurar foco despois dun retraso para permitir que a UI se reconstrua.
      if (expanded && _lastFocusedNode != null) {
        Future.delayed(_animationDuration, () {
          if (mounted && _lastFocusedNode != null && _lastFocusedNode!.canRequestFocus) {
            _lastFocusedNode!.requestFocus();
            Debug.info("$tag: Foco restaurado.");
            _lastFocusedNode = null; // Limpiar a referencia unha vez restaurado
          } else {
             Debug.warn("$tag: Non se puido restaurar o foco.");
          }
        });
      } else if (!expanded) {
         // Se estamos colapsando, limpar o foco se está dentro deste contenedor
          if (currentFocus != null && currentFocus.context != null && context != null && currentFocus.context!.findAncestorStateOfType<State<LdFoldableContainer>>() == this) {
             currentFocus.unfocus();
             Debug.info("$tag: Foco dentro do contenedor colapsado. Eliminando foco.");
          }
          _lastFocusedNode = null; // Limpar referencia cando colapsamos
      }


      // Chamar o callback onExpansionChanged se existe.
      final onExpansionChangedCallback = widget.config[efOnExpansionChanged] as Function(bool)?;
      if (onExpansionChangedCallback != null) {
        onExpansionChangedCallback(expanded);
        Debug.info("$tag: Executando callback onExpansionChanged con estado $expanded.");
      }
    } else {
       Debug.info("$tag: setExpanded($expanded) chamado, pero o estado xa é $expanded. Non facemos nada.");
    }
  }

  /// Alterna o estado de expansión do contenedor.
  void toggleExpanded() {
    Debug.info("$tag: Alternando estado de expansión.");
    setExpanded(!isExpanded);
  }

  /// Gesti  da pressi  na cabeceira.
  void _handleHeaderTap() {
    Debug.info("$tag: Cabeceira do contenedor premida.");
    // Se a interacci  est  habilitada, alternar o estado
    if (widget.config[cfEnableInteraction] as bool? ?? true) {
      toggleExpanded();
    }

    // Chamar o callback onHeaderTap se existe.
    final onHeaderTapCallback = widget.config[efOnHeaderTap] as VoidCallback?;
    if (onHeaderTapCallback != null) {
      onHeaderTapCallback();
       Debug.info("$tag: Executando callback onHeaderTap.");
    }
  }


  // CONSTRUCIÓN DO WIDGET VISUAL =========================
  @override
  Widget buildContent(BuildContext context) {
    Debug.info("$tag: Construíndo contido. isVisible=${widget.isVisible}, isEnabled=${widget.isEnabled}, isExpanded=${containerModel?.isExpanded}.");

    // Assegurar-se que o estado se mantén vivo.
    // A pesar do nome do mixin, `wantKeepAlive` non se chama automaticamente.
    // Debes chamar `updateKeepAlive()` no teu método `build` ou onde o estado relevante cambie.
    super.build(context); // <-- Chamar super.build(context) para que updateKeepAlive() funcione.


    final config = widget.config;
    final model = containerModel; // Usamos o getter seguro

    // Se non hai modelo, mostrar contedor buido ou recuperar-lo (a recuperación faise en _createModel)
    if (model == null) {
      Debug.warn("$tag: Modelo non disponible. Mostrando contedor de recambio.");
      return Container(
        height: 50,
        width: double.infinity,
        color: Colors.red.withOpacity(0.3), // Cor para depuraci  visualmente clara
        child: Center(child: Text("Erro: Modelo non cargado\n($tag)", textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
      );
    }

    // Obter o tema actual
    final theme = Theme.of(context);

    // Obter configuración da UI
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


    // Widget cabeceira personalizada ou cabeceira por defecto
    final headerWidget = config[cfHeader] as Widget?;

    // Construír a cabeceira
    final header = headerWidget ??
        GestureDetector(
          onTap: _handleHeaderTap,
          behavior: HitTestBehavior.opaque, // Permite detectar taps na área transparente do contenedor
          child: Container(
            height: headerHeight,
            decoration: BoxDecoration(
              color: headerBackgroundColor,
              borderRadius: showBorder
                  ? BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(model.isExpanded ? 0 : borderRadius), // Bordes redondeados abaixo só cando colapsado
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
                // Espacio para título e subtítulo
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      if (model.titleKey != null)
                        Text(
                          model.titleKey!.tx(), // Obtemos o título traducido do modelo
                          style: titleStyle,
                          overflow: TextOverflow.ellipsis, // Evitar desbordamento
                        ),
                      // Subtítulo
                      if (model.subtitleKey != null)
                        Text(
                          model.subtitleKey!.tx(), // Obtemos o subtítulo traducido do modelo
                          style: subtitleStyle,
                          overflow: TextOverflow.ellipsis, // Evitar desbordamento
                        ),
                    ],
                  ),
                ),
                // Accións da cabeceira
                ...headerActions,
                // Botón de expansión
                IconButton(
                  icon: Icon(model.isExpanded ? expansionIcon : collapsedIcon),
                  onPressed: () => toggleExpanded(), // Alternar estado ao premer o icono
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(), // Eliminar padding/tamaño mínimo
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        );

    // Widget contido
    final contentWidget = config[cfContent] as Widget? ?? const SizedBox.shrink();

    // Construír o contedor com animación
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupar todo o ancho dispoñible
      children: [
        // Cabeceira (sempre visible)
        header,
        // Contido (com animación de altura)
        AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          // Altura: 0 cando colapsado, ou altura automática cando expandido.
          // Usamos unha altura finita (double.infinity) com SingleChildScrollView para evitar erros
          // 'unbounded constraints' com AnimatedContainer.
          height: model.isExpanded ? null : 0.0, // Usamos null para altura automática cando expandido

          clipBehavior: Clip.antiAlias, // Recortar contido que desborde durante a animación
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
                    bottom: BorderSide(color: borderColor, width: borderWidth), // Borde na parte inferior do contido
                  )
                : null,
          ),
          // Usamos Visibility para controlar a visibilidade do contido sen descartar a árbore de widgets
          child: Visibility(
            visible: model.isExpanded, // Visible se está expandido
            maintainState: true, // Manteñen o estado dos widgets internos
            maintainAnimation: true, // Manteñen as animacións dos widgets internos
            maintainSize: false, // Non reservan espazo cando non visible (as animacións manexan a altura)
            child: SingleChildScrollView( // Engadir scroll ao contido para evitar desbordamento se é moi grande
              physics: model.isExpanded ? null : const NeverScrollableScrollPhysics(), // Deshabilitar scroll cando colapsado
              child: Padding(
                padding: contentPadding,
                child: contentWidget, // O widget de contido proporcionado ao constructor
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => containerModel?.isExpanded ?? false; // Manter vivo se está expandido (ou sempre true se se quere). Decidimos manter vivo SÓ SE est  expandido.

}