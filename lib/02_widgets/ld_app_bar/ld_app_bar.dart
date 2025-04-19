// ld_app_bar.dart
// Widget adaptat per a la barra de capçalera de cada pàgina.
// CreatedAt: 2025/02/09 dc. JIQ

import 'dart:async';

import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar_ctrl.dart';
import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar_model.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';

/// Widget adaptat per a la barra de capçalera de cada pàgina.
class      LdAppBar
extends    LdWidget {
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
  @override LdWidgetCtrl createState() => wCtrl;

  @override
  StreamSubscription<StreamEnvelope<LdModel>>? sLstn;

  @override
  StreamSubscription<StreamEnvelope<LdModel>>? vSub;

  @override
  void listened(StreamEnvelope<LdModel> pEnv) {
    // TODO: implement listened
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
