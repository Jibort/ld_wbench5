// ld_scaffold_ctrl.dart
// Controlador del widget 'LdScaffold'.
// CreatedAt: 2025/04/18 dv. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/02_widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/debug.dart';
import 'package:ld_wbench5/10_tools/full_set.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Controlador del widget 'LdScaffold'.
class   LdScaffoldCtrl 
extends LdWidgetCtrl<LdScaffold> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdScaffoldCtrl";
  
  // 🧩 MEMBRES ------------------------
  final OnceSet<LdAppBar> _appBar = OnceSet<LdAppBar>();
  final FullSet<Widget>   _body   = FullSet<Widget>();
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdScaffoldCtrl({ 
    required super.pView, 
    required super.pWidget,
    String? pTag,
    String? pAppBarTag,
    required String pTitle,
    String? pSubTitle,
    required Widget pBody }) {
      _body.set(pBody);	
      _appBar.set(LdAppBar(
        key:       null, 
        pTag:      pAppBarTag,
        pView:     view, 
        pTitle:    pTitle, 
        pSubTitle: pSubTitle,
      )
    );
  }

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdScaffoldCtrl.className;

  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'LdOnDisposableIntf': Called when this object is removed from the tree permanently.
  @override
  void onDispose() {
    Debug.info("[$tag.onDispose()]: Instància completament eliminada.");
  }
  
  /// 📍 'LdCtrlLifecycleIntf': Equivalent a deactivate
  @override
  void onDeactivate() {
    Debug.info("[$tag.onDeactivate()]: Instància eliminada de l'arbre.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Equivalent a initState
  @override
  void onInit() {
    Debug.info("[$tag.onInit()]: Instància inserida a l'arbre.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didChangeDependencies
  @override
  void onDependenciesResolved() {
    Debug.info("[$tag.onDependenciesResolved()]: Dependència actualitzada.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Opcional, notifica quan la vista ha estat construïda.
  @override
  void onRendered(BuildContext pBCtx) {
    Debug.info("[$tag.onInit()]: Instància inserida a l'arbre.");
  }


  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didUpdateWidget
  @override
  void onWidgetUpdated(covariant LdScaffold pOldWidget) {
    widget = pOldWidget;
    Debug.info("[$tag.onInit()]: Instància inserida a l'arbre.");
  }
  
  // ⚙️📍 FUNCIONALITAT ----------------
  /// Creació de tot l'arbre de components de 'LdAppbar'.
  @override
  Widget buildWidget(BuildContext pBCtx) 
    => Scaffold(
      key: null,      
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
        child: _appBar.get(),
      ),
      body: _body.get(),
    );
}
