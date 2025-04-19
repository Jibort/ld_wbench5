// ld_scaffold.dart
// Widget principal de cada pàgina.
// CreatedAt: 2025/02/09 dc. JIQ

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/02_widgets/ld_scaffold/ld_scaffold_ctrl.dart';
import 'package:ld_wbench5/02_widgets/ld_scaffold/ld_scaffold_model.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';

class LdScaffold
extends LdWidget {
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
 {  wModel = LdScaffoldModel(pView: view, pWidget: this);
    _tagAppBar = LdTagBuilder.newWidgetTag(LdAppBar.className);
    wCtrl = LdScaffoldCtrl(
      pView: view, 
      pWidget: this,
      pAppBarTag: _tagAppBar,
      pTitle: pTitle,
      pSubTitle: pSubTitle,
      pBody: pBody,
    );
  }

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdScaffold.className;

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override
  LdScaffoldCtrl createState() => wCtrl;

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

  // 🪟 GETTERS I SETTERS --------------
  @override LdScaffoldCtrl get wCtrl   => super.wCtrl as LdScaffoldCtrl;
  @override LdScaffoldModel get wModel => super.wModel as LdScaffoldModel;

}

