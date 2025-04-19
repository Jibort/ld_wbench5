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
import 'package:ld_wbench5/03_core/interfaces/ld_widget_intf.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/events/rebuild_event.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/08_theme/events/theme_model.dart';
import 'package:ld_wbench5/09_intl/events/lang_changed_event.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

/// 📱 LdButton 
/// 
/// Component 'botó' personalitzable amb funcionalitats com:
/// - Canvi d'activació/desactivació
/// - Visibilitat dinàmica
/// - Mode principal/secundari amb estils diferenciats
/// - Icona opcional a l'esquerra del text
class LdButton 
extends LdWidget {
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
  @override LdWidgetCtrl<LdWidgetIntf> createState() => wCtrl;

  @override
  StreamSubscription<StreamEnvelope<LdModel>>? sLstn;

  @override
  StreamSubscription<StreamEnvelope<LdModel>>? vSub;

  @override
  void listened(StreamEnvelope<LdModel> pEnv) {
    if (pEnv.tgtTags.isEmpty || pEnv.tgtTags.contains(tag)) {
      Debug.info("${tag}listened(pEnv): iniciat ...");
      if (pEnv.hasModel) {
        switch (pEnv.model) {
        case ThemeEventModel _:
        case LangChangedEvent _:
          wCtrl.setState((){});
          break;
        } 
      } else {
        switch (pEnv) {
      case RebuildEvent _:
      case LangChangedEvent _:
        wCtrl.setState((){});
        break;
      }
      }
      Debug.info("${tag}listened(pEnv): ... acabat");
    }
  }

  @override
  void onDone() {
    // TODO: implement onDone
  }

  @override
  void onError(Object pError, StackTrace pSTrace) {
    // TODO: implement onError
  }

}
