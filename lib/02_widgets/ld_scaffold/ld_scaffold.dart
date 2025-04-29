// ld_scaffold.dart
// Widget principal de cada pàgina.
// CreatedAt: 2025/02/09 dc. JIQ

import 'package:flutter/widgets.dart';

import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/02_widgets/ld_scaffold/ld_scaffold_ctrl.dart';
import 'package:ld_wbench5/02_widgets/ld_scaffold/ld_scaffold_model.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_widget_abs.dart';
import 'package:ld_wbench5/03_core/event/view/view_event.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_stream_listener_intf.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';

class LdScaffold
extends LdWidgetAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdScaffold";
  late final String _tagAppBar;
  
  // 🧩 MEMBRES ------------------------
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdScaffold({ 
    required super.key, 
    required super.pView,
    required String pTitle,
    String? pSubTitle,
    Widget pBody = const SizedBox() })
 {  _tagAppBar = LdTagBuilder.newWidgetTag(LdAppBar.className);
    wModel = LdScaffoldModel(pView: view, pWidget: this);
    wCtrl = LdScaffoldCtrl(
      pView: view, 
      pWidget: this as LdWidgetAbs,
      pAppBarTag: _tagAppBar,
      pTitle: pTitle,
      pSubTitle: pSubTitle,
      pBody: pBody,
    );
  }

  // 🪟 GETTERS I SETTERS --------------
  @override LdScaffoldCtrl get wCtrl => super.wCtrl as LdScaffoldCtrl;
  @override LdScaffoldModel get wModel => super.wModel as LdScaffoldModel;

  @override
  set wCtrl(LdScaffoldCtrl pCtrl) {
    // TODO: implement wCtrl
  }

  @override
  set wModel(LdScaffoldModel pModel) {
    // TODO: implement wModel
  }

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdScaffold.className;

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override
  LdScaffoldCtrl createState() => wCtrl;

  @override cancelAllSubscriptions() {
    // TODO: implement cancelAllSubscriptions
  }

  @override disposeSubscriptions() {
    // TODO: implement disposeSubscriptions
  }

  @override unsubscribeFromEmitter(LdStreamListenerAbs pLstn) {
    // TODO: implement unsubscribeFromEmitter
  }
  

  @override listenViewEvent(ViewEvent pEnv) {
    // TODO: implement listenViewEvent
  }
  
  @override onViewStreamDone() {
    // TODO: implement onViewStreamDone
  }
  
  @override onViewStreamError(Object pError, StackTrace pTrace) {
    // TODO: implement onViewStreamError
  }
}