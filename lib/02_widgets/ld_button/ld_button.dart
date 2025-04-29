// ld_button.dart
// Component de botó personalitzable amb funcionalitats com:
// - Canvi d'activació/desactivació
// - Visibilitat dinàmica
// - Mode principal/secundari amb estils diferenciats
// - Icona opcional a l'esquerra del text
// CreatedAt: 2025/04/14 dg. CLA[JIQ]

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/02_widgets/ld_button/ld_button_ctrl.dart';
import 'package:ld_wbench5/02_widgets/ld_button/ld_button_model.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_widget_abs.dart';
import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_ctrl_abs.dart';

/// Component 'botó' personalitzable.
class LdButton
extends LdWidgetAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdButton";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdButton({
    required super.key, 
    required super.pView,
    super.pTag,
    bool isEnabled   = true,
    bool isVisible   = true,
    bool isFocusable = true,
    bool isPrimary   = true,
    required String     text,
    VoidCallback?       onPressed,
    IconData?           leftIcon,
    double?             width,
    double?             height,
    double?             elevation,
    BorderRadius?       borderRadius,
    EdgeInsetsGeometry? pPadding,
    Color?              primaryColor,
    Color?              primaryTextColor,
    Color?              secondaryColor,
    Color?              secondaryTextColor,
    Color?              disabledColor,
    Color?              disabledTextColor,
    TextStyle?          pTextStyle,
    bool                expanded = false,
    MainAxisSize        mainAxisSize = MainAxisSize.min,
    MainAxisAlignment   mainAxisAlignment = MainAxisAlignment.center,
    CrossAxisAlignment  crossAxisAlignment = CrossAxisAlignment.center, })
  { wModel = LdButtonModel(
        pView:   view,
        pWidget: this,
        pText:   text, 
      );
    wCtrl = LdButtonCtrl(
      pView: super.view,
      pWidget: this,
      isEnabled: isEnabled,
      isVisible: isVisible,
      isFocusable: isFocusable,
      isPrimary: isPrimary,
      onPressed: onPressed,
      leftIcon: leftIcon,
      width: width,
      height: height ?? 45.0.h,
      elevation: elevation ?? 0.0.h,
      borderRadius: borderRadius,
      pPadding: pPadding ?? EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
      primaryColor: primaryColor,
      primaryTextColor: primaryTextColor,
      secondaryColor: secondaryColor,
      secondaryTextColor: secondaryTextColor,
      disabledColor: disabledColor,
      disabledTextColor: disabledTextColor,
      pTextStyle: pTextStyle,
      expanded: expanded,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }
  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdButton.className;

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override LdWidgetCtrlAbs createState() => wCtrl;

  @override
  StreamSubscription<StreamEvent>? vSub;

  @override listenViewEvent(covariant StreamEvent pEnv) {
    // TODO: implement listenViewEvent
  }
  
  @override onViewStreamDone() {
    // TODO: implement onViewStreamDone
  }
  
  @override
  void onViewStreamError(Object pError, StackTrace pTrace) {
    // TODO: implement onViewStreamError
  }
}
