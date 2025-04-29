// ld_app_bar.dart
// Widget adaptat per a la barra de capçalera de cada pàgina.
// CreatedAt: 2025/02/09 dc. JIQ

import 'dart:async';

import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar_ctrl.dart';
import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar_model.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_widget_abs.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_ctrl_abs.dart';

/// Widget adaptat per a la barra de capçalera de cada pàgina.
class      LdAppBar
extends    LdWidgetAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdAppBar";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdAppBar({ 
    required super.key, 
    required super.pView,
    super.pTag,
    bool isEnabled   = true,
    bool isVisible   = true,
    bool isFocusable = false,
    required String pTitle,
    String? pSubTitle })
  { wModel = LdAppBarModel(
      pView:     view,
      pWidget:   this,
      pTitle:    pTitle, 
      pSubTitle: pSubTitle
    );
    wCtrl = LdAppBarCtrl(
      pView: super.view, 
      pWidget: this,
      isEnabled: isEnabled,
      isVisible: isVisible,
      isFocusable: isFocusable,
      pTag: LdTagBuilder.newWidgetTag(LdAppBar.className),
    );
  }

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdAppBar.className;

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override LdWidgetCtrlAbs createState() => wCtrl;

  @override
  StreamSubscription<StreamEvent>? vSub;
  
  // 📍 'ViewListenerIntf' =====================================================
  /// 📍 'ViewListenerIntf': Gestió dels events de la vista.
  @override listenViewEvent(StreamEvent pEnv) {
    // TODO: implement listenViewEvent
  }
  
  /// 📍 'ViewListenerIntf': Gestió ??? a l'Stream de la vista.
  @override onViewStreamDone() {
    // TODO: implement onViewStreamDone
  }
  
  /// 📍 'ViewListenerIntf': Gestió dels errors a l'Stream de la vista.
  @override onViewStreamError(Object pError, StackTrace pTrace) {
    // TODO: implement onViewStreamError
  }
}
