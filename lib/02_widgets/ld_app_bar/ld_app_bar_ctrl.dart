// ld_app_bar_ctrl.dart
// Controlador pel widget 'LdAppBar'.
// CreatedAt: 2025/04/18 dv. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/02_widgets/ld_app_bar/ld_app_bar_model.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

/// Controlador pel widget 'LdAppBar'.
class   LdAppBarCtrl 
extends LdWidgetCtrl<LdAppBar> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdAppBarCtrl";
  
  // 🧩 MEMBRES ------------------------
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------  
  /// Constructor base del controlador.
  LdAppBarCtrl({ 
    required super.pView, 
    required super.pWidget,
    super.pTag,
    super.isEnabled,
    super.isVisible,
    super.isFocusable,
  });

  /// 📍 'LdOnDisposableIntf': Called when this object is removed from the tree permanently.
  @override
  void onDispose() {
    Debug.info("[$tag.onDispose()]: Instància completament eliminada.");
  }
  
  // 🪟 GETTERS I SETTERS --------------
  LdAppBarModel get wModel => widget.wModel as LdAppBarModel;

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdAppBarCtrl.className;

  // ♻️ CLICLE DE VIDA ----------------
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
  void onWidgetUpdated(covariant LdAppBar pOldWidget) {
    widget = pOldWidget;
    Debug.info("[$tag.onInit()]: Instància inserida a l'arbre.");

  }
  
  // ⚙️📍 FUNCIONALITAT ----------------
  /// Creació de tot l'arbre de components de 'LdAppbar'.
  @override
  Widget buildWidget(BuildContext pBCtx) 
    => AppBar(
        title: (view.vModel.subTitle == null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wModel.title)
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wModel.title),
                Text(wModel.subTitle!),
              ],
            ),
      actions: [],
    );
}
