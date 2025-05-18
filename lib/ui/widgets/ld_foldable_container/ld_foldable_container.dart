// lib/ui/widgets/ld_foldable_container/ld_foldable_container.dart
// Contenidor amb capçalera i contingut plegable
// Created: 2025/05/17 ds. CLA

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container_ctrl.dart';

export 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container_ctrl.dart';
export 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container_model.dart';

/// Contenidor amb capçalera permanent i contingut plegable.
///
/// Permet mostrar una capçalera amb títol, subtítol i accions, i un contingut
/// que es pot expandir o contreure mitjançant un botó a la capçalera.
class LdFoldableContainer extends LdWidgetAbs {
  /// Constructor principal
  LdFoldableContainer({
    Key? key,
    super.pTag,
    Widget? header,
    Widget? content,
    String? titleKey,
    String? subtitleKey,
    List<Widget>? headerActions,
    bool initialExpanded = true,
    double headerHeight = 56.0,
    Color? headerBackgroundColor,
    Color? contentBackgroundColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double borderRadius = 8.0,
    Color? borderColor,
    double borderWidth = 1.0,
    bool showBorder = true,
    IconData? expansionIcon,
    IconData? collapsedIcon,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? contentPadding,
    bool enableInteraction = true,
    Duration? animationDuration,
    Function(bool)? onExpansionChanged,
    VoidCallback? onHeaderTap,
  }) : super(pKey: key, pConfig: {
    // Configuració (cf)
    cfHeader: header,
    cfContent: content,
    cfHeaderHeight: headerHeight,
    cfHeaderBackgroundColor: headerBackgroundColor,
    cfContentBackgroundColor: contentBackgroundColor,
    cfHeaderActions: headerActions,
    cfTitleStyle: titleStyle,
    cfSubtitleStyle: subtitleStyle,
    cfBorderRadius: borderRadius,
    cfBorderColor: borderColor,
    cfBorderWidth: borderWidth,
    cfShowBorder: showBorder,
    cfExpansionIcon: expansionIcon,
    cfCollapsedIcon: collapsedIcon,
    cfHeaderPadding: headerPadding,
    cfContentPadding: contentPadding,
    cfEnableInteraction: enableInteraction,
    cfAnimationDuration: animationDuration,
    
    // Model (mf)
    mfIsExpanded: initialExpanded,
    mfTitleKey: titleKey,
    mfSubtitleKey: subtitleKey,
    
    // Events (ef)
    efOnExpansionChanged: onExpansionChanged,
    efOnHeaderTap: onHeaderTap,
  }) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: LdFoldableContainer creat");
  }

  @override
  LdFoldableContainerCtrl createCtrl() => LdFoldableContainerCtrl(this);
  
  /// Accés al controlador amb tipus específic
  LdFoldableContainerCtrl? get containerCtrl => ctrl as LdFoldableContainerCtrl?;
  
  /// Indica si el contenidor està expandit
  bool get isExpanded => containerCtrl?.isExpanded ?? true;
  
  /// Estableix l'estat d'expansió del contenidor.
  void  setExpanded(bool pIsExpanded) 
  => (pIsExpanded)
    ? expand()
    : collapse();

  /// Expandeix el contenidor
  void expand() => containerCtrl?.setExpanded(true);
  
  /// Contrau el contenidor
  void collapse() => containerCtrl?.setExpanded(false);
  
  /// Alterna l'estat d'expansió
  void toggle() => containerCtrl?.toggleExpanded();
}