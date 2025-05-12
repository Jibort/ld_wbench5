// lib/ui/widgets/ld_app_bar.dart
// Widget de la barra d'aplicació personalitzada
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/05 dl. CLA - Millora del suport d'internacionalització

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar_ctrl.dart';
import 'package:ld_wbench5/core/map_fields.dart';

/// Widget AppBar personalitzat
/// 
/// Implementa AppBar de Flutter amb l'arquitectura unificada
/// Tota la lògica està al [LdAppBarCtrl].
class      LdAppBar 
extends    LdWidgetAbs
implements PreferredSizeWidget {
  
  @override
  final Size preferredSize;
  
  LdAppBar({
    String? pTag,
    Key? key,
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? elevation,
    double? scrolledUnderElevation,
    NotificationListenerCallback<ScrollNotification>? notificationPredicate,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? backgroundColor,
    Color? foregroundColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool primary = true,
    bool? centerTitle,
    bool excludeHeaderSemantics = false,
    double? titleSpacing,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
    double? toolbarHeight,
    double? leadingWidth,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Clip? clipBehavior,
  }) : preferredSize = _PreferredAppBarSize(
         toolbarHeight ?? kToolbarHeight,
         bottom?.preferredSize.height ?? 0.0,
       ),
       super(pTag: pTag, key: key) {
    
    // Configurar tots els camps
    final map = <String, dynamic>{
      cfTitle: title,
      cfLeading: leading,
      cfActions: actions,
      cfFlexibleSpace: flexibleSpace,
      cfBottom: bottom,
      cfElevation: elevation,
      cfScrolledUnderElevation: scrolledUnderElevation,
      cfNotificationPredicate: notificationPredicate,
      cfShadowColor: shadowColor,
      cfSurfaceTintColor: surfaceTintColor,
      cfBackgroundColor: backgroundColor,
      cfForegroundColor: foregroundColor,
      cfIconTheme: iconTheme,
      cfActionsIconTheme: actionsIconTheme,
      cfPrimary: primary,
      cfCenterTitle: centerTitle,
      cfExcludeHeaderSemantics: excludeHeaderSemantics,
      cfTitleSpacing: titleSpacing,
      cfToolbarOpacity: toolbarOpacity,
      cfBottomOpacity: bottomOpacity,
      cfToolbarHeight: toolbarHeight,
      cfLeadingWidth: leadingWidth,
      cfToolbarTextStyle: toolbarTextStyle,
      cfTitleTextStyle: titleTextStyle,
      cfSystemOverlayStyle: systemOverlayStyle,
      cfForceMaterialTransparency: forceMaterialTransparency,
      cfClipBehavior: clipBehavior,
    };
    
    mapsService.updateMap(mTag, map);
  }

  @override
  LdAppBarCtrl createCtrl() => LdAppBarCtrl(pTag: mTag);

  @override
  Widget build(BuildContext context) {
    return wCtrl.buildWidget(context);
  }
}

/// Implementació privada per PreferredSize
class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(double height, double bottom)
      : super.fromHeight(height + bottom);
}