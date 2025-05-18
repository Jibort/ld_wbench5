// lib/ui/widgets/ld_foldable_container/ld_foldable_container_ctrl.dart
// Controlador del widget LdFoldableContainer
// Created: 2025/05/17 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';
import 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container.dart';

/// Controlador del widget LdFoldableContainer
class LdFoldableContainerCtrl extends LdWidgetCtrlAbs<LdFoldableContainer> {
  // MEMBRES ==============================================
  /// Duració de l'animació d'expansió
  late final Duration _animationDuration;
  
  /// Indica si el contingut està expandit
  bool get isExpanded => (model as LdFoldableContainerModel?)?.isExpanded ?? true;

  // CONSTRUCTORS/DESTRUCTORS ============================
  /// Constructor
  LdFoldableContainerCtrl(super.pWidget);

  // FUNCIONALITAT =======================================
  @override
  void initialize() {
    // Obtenir la duració de l'animació o establir valor per defecte
    _animationDuration = widget.config[cfAnimationDuration] as Duration? 
      ?? const Duration(milliseconds: 300);
    
    // Crear el model si és necessari
    if (model == null) {
      // Assegurar-nos que cfTag mai és null per evitar errors de tipatge
      final modelConfig = {
        cfTag: tag, // Sempre utilitzar tag del controlador com a fallback
        mfIsExpanded: widget.config[mfIsExpanded] as bool? ?? true,
      };
      
      // Afegir altres propietats només si no són nul·les
      final titleKey = widget.config[mfTitleKey] as String?;
      if (titleKey != null) {
        modelConfig[mfTitleKey] = titleKey;
      }
      
      final subtitleKey = widget.config[cfSubTitleKey] as String?;
      if (subtitleKey != null) {
        modelConfig[mfSubtitleKey] = subtitleKey;
      }
      
      model = LdFoldableContainerModel.fromMap(modelConfig);
    }
  }

  @override
  void update() {
    // No cal fer res per ara
  }

  @override
  void onEvent(LdEvent event) {
    // Gestionar canvis d'idioma
    if (event.eType == EventType.languageChanged) {
      if (mounted) {
        setState(() {
          // Reconstruïm després del canvi d'idioma
        });
      }
    }
  }
  
  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfnUpdate) {
    // Executar l'acció d'actualització
    pfnUpdate();
    
    // Reconstruir si està muntat
    if (mounted) {
      setState(() {
        // Reconstruïm després del canvi del model
      });
    }
  }
  
  /// Estableix l'estat d'expansió
  void setExpanded(bool expanded) {
    final containerModel = model as LdFoldableContainerModel?;
    if (containerModel != null && containerModel.isExpanded != expanded) {
      containerModel.isExpanded = expanded;
      
      // Cridar el callback onExpansionChanged si existeix
      final callback = widget.config[efOnExpansionChanged] as Function(bool)?;
      if (callback != null) {
        callback(expanded);
      }
    }
  }
  
  /// Alterna l'estat d'expansió
  void toggleExpanded() {
    setExpanded(!isExpanded);
  }
  
  /// Gestiona el tap a la capçalera
  void _handleHeaderTap() {
    // Si la interacció està habilitada, alternar l'estat
    if (widget.config[cfEnableInteraction] as bool? ?? true) {
      toggleExpanded();
    }
    
    // Cridar el callback onHeaderTap si existeix
    final callback = widget.config[efOnHeaderTap] as VoidCallback?;
    if (callback != null) {
      callback();
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final config = widget.config;
    final containerModel = model as LdFoldableContainerModel?;
    
    // Si no hi ha model, mostrar container buit
    if (containerModel == null) {
      return Container();
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
    
    // Widget capçalera personalitzat o capçalera per defecte
    final headerWidget = config[cfHeader] as Widget?;
    
    // Construir la capçalera
    final header = headerWidget ?? GestureDetector(
      onTap: _handleHeaderTap,
      child: Container(
        height: headerHeight,
        decoration: BoxDecoration(
          color: headerBackgroundColor,
          borderRadius: showBorder 
            ? BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(isExpanded ? 0 : borderRadius),
                bottomRight: Radius.circular(isExpanded ? 0 : borderRadius),
              )
            : null,
          border: showBorder ? Border.all(
            color: borderColor,
            width: borderWidth,
          ) : null,
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
                  if (containerModel.titleKey != null)
                    Text(
                      containerModel.titleKey!.tx(),
                      style: titleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  // Subtítol
                  if (containerModel.subtitleKey != null)
                    Text(
                      containerModel.subtitleKey!.tx(),
                      style: subtitleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            
            // Accions de la capçalera
            ...headerActions,
            
            // Botó d'expansió
            IconButton(
              icon: Icon(containerModel.isExpanded ? expansionIcon : collapsedIcon),
              onPressed: () => toggleExpanded(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
    
    // Widget contingut o widget buit
    final content = config[cfContent] as Widget? ?? const SizedBox.shrink();
    
    // Construir el contenidor amb animació
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Capçalera (sempre visible)
        header,
        
        // Contingut (amb animació)
        AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          height: containerModel.isExpanded ? null : 0.0,
          decoration: BoxDecoration(
            color: contentBackgroundColor,
            borderRadius: showBorder ? BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ) : null,
            border: showBorder ? Border(
              left: BorderSide(color: borderColor, width: borderWidth),
              right: BorderSide(color: borderColor, width: borderWidth),
              bottom: BorderSide(color: borderColor, width: borderWidth),
            ) : null,
          ),
          padding: EdgeInsets.zero,
          child: ClipRect(
            child: AnimatedOpacity(
              opacity: containerModel.isExpanded ? 1.0 : 0.0,
              duration: _animationDuration,
              child: containerModel.isExpanded
                ? Padding(
                    padding: contentPadding,
                    child: content,
                  )
                : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}