// ld_scaffold.dart
// Widget principal de cada pàgina.
// CreatedAt: 2025/02/09 dc. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/02_widgets/ld_app_bar.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

class LdScaffold
extends LdWidget<LdScaffoldCtrl, LdScaffold> {
  // 🧩 MEMBRES ------------------------
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdScaffold({ 
    required super.key, 
    required super.pView,
    required String pTitle,
    String? pSubTitle }) {
      super.wCtrl = LdScaffoldCtrl(
        pView: super.view, 
        pWidget: this,
        pTitle: pTitle,
        pSubTitle: pSubTitle,
      );
  }

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => "LdAppbar";

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override
  LdWidgetCtrl<LdScaffoldCtrl, LdScaffold> createState()  => super.wCtrl;

  // 🪟 GETTERS I SETTERS --------------
}

class   LdScaffoldCtrl 
extends LdWidgetCtrl<LdScaffoldCtrl, LdScaffold> {
  // 🧩 MEMBRES ------------------------
  final LdAppBar _appBar;
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdScaffoldCtrl({ 
    required super.pView, 
    required super.pWidget,
    String? pTag,
    required String pTitle,
    String? pSubTitle })
    : _appBar = LdAppBar(
        key:       null, 
        pView:     pView, 
        pTitle:    pTitle, 
        pSubTitle: pSubTitle,
      );

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => "LdAppbarCtrl";

  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'LdOnDisposableIntf': Called when this object is removed from the tree permanently.
  @override
  void onDispose() {
    Debug.info("[$tag.onDispose()]: Instància completament eliminada.");
    super.onDispose();
  }
  
  /// 📍 'LdCtrlLifecycleIntf': Equivalent a deactivate
  @override
  void onDeactivate() {
    Debug.info("[$tag.onDeactivate()]: Instància eliminada de l'arbre.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Equivalent a initState
  @override
  void onInit() {
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didChangeDependencies
  @override
  void onDependenciesResolved() {
    Debug.info("[$tag.onDependenciesResolved()]: Dependència actualitzada.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Opcional, notifica quan la vista ha estat construïda.
  @override
  void onRendered(BuildContext pBCtx) {
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");
  }


  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didUpdateWidget
  @override
  void onWidgetUpdated(covariant LdScaffold pOldWidget) {
    widget = pOldWidget;
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");
  }
  
  // ⚙️📍 FUNCIONALITAT ----------------
  /// Creació de tot l'arbre de components de 'LdAppbar'.
  @override
  Widget buildWidget(BuildContext pBCtx) 
    => Scaffold(
        key: null,      
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
          child: _appBar,
        ),
    );
}
