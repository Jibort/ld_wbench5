// ld_button_model.dart
// Model del widget LdButton.
// Created: 2025-05-01 dc. JIQ
// Updated: 2025/05/11 dg. CLA - Actualització a l'arquitectura final de widgets,pagines i prefixs.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold_ctrl.dart';
import 'package:ld_wbench5/core/map_fields.dart';

/// Widget Scaffold personalitzat
/// 
/// Hereta de [LdWidgetAbs] per utilitzar l'arquitectura unificada
/// amb GlobalKey i LdTaggableMixin.
/// 
/// Tota la lògica està al [LdScaffoldCtrl].
class   LdScaffold 
extends LdWidgetAbs {
  LdScaffold({
    super.pTag,
    Color? backgroundColor,
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    List<Widget>? persistentFooterButtons,
    Widget? drawer,
    Widget? endDrawer,
    Widget? bottomNavigationBar,
    Widget? bottomSheet,
    DragStartBehavior drawerDragStartBehavior = DragStartBehavior.start,
    bool extendBody = false,
    bool extendBodyBehindAppBar = false,
    Color? drawerScrimColor,
    double? drawerEdgeDragWidth,
    bool drawerEnableOpenDragGesture = true,
    bool endDrawerEnableOpenDragGesture = true,
    bool? resizeToAvoidBottomInset,
  }) {
    // Configurar tots els camps
    final map = <String, dynamic>{
      cfBackgroundColor: backgroundColor,
      cfAppBar: appBar,
      cfBody: body,
      cfFloatingActionButton: floatingActionButton,
      cfFloatingActionButtonLocation: floatingActionButtonLocation,
      cfFloatingActionButtonAnimator: floatingActionButtonAnimator,
      cfPersistentFooterButtons: persistentFooterButtons,
      cfDrawer: drawer,
      cfEndDrawer: endDrawer,
      cfBottomNavigationBar: bottomNavigationBar,
      cfBottomSheet: bottomSheet,
      cfDrawerDragStartBehavior: drawerDragStartBehavior,
      cfExtendBody: extendBody,
      cfExtendBodyBehindAppBar: extendBodyBehindAppBar,
      cfDrawerScrimColor: drawerScrimColor,
      cfDrawerEdgeDragWidth: drawerEdgeDragWidth,
      cfDrawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      cfEndDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      cfResizeToAvoidBottomInset: resizeToAvoidBottomInset,
    };
    
    mapsService.updateMap(mTag, map);
  }

  @override
  LdScaffoldCtrl createCtrl() => LdScaffoldCtrl(pTag: mTag);

  @override
  Widget build(BuildContext context) {
    return wCtrl.buildWidget(context);
  }
}