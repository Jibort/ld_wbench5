// ld_app_bar.dart
// Widget adaptat per a la barra de títol.
// CreatedAt: 2025/02/09 dc. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

/// Widget adaptat per a la barra de títol.
class   LdAppBar
extends LdWidget<LdAppbarCtrl, LdAppBar> {
  // 🧩 MEMBRES ------------------------
  static final String _appBarTag = LdTagBuilder.newWidgetTag("LdAppBar");
  String  _title;
  String? _subTitle;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdAppBar({ 
    required super.key, 
    required super.pView,
    String? pTag,
    required String pTitle,
    String? pSubTitle })
  : _title = pTitle,
    _subTitle = pSubTitle,
    super(pTag: pTag?? _appBarTag) {
    super.wCtrl = LdAppbarCtrl(
      pView: super.view, 
      pWidget: this,
      pTag: LdTagBuilder.newWidgetTag("LdAppbarCtrl"),
    );
  }

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => "LdAppbar";

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override
  LdWidgetCtrl<LdAppbarCtrl, LdAppBar> createState()  => super.wCtrl;

  // 🪟 GETTERS I SETTERS --------------
  String get title => _title;
  set title(String pTitle) => super.wCtrl.setState(() =>  _title = pTitle);
  String? get subTitle => _subTitle;
  set subTitle(String? pSubTitle) => super.wCtrl.setState(() =>  _subTitle = pSubTitle);
  void setTitles({ required String pTitle, String? pSubTitle }) {
    super.wCtrl.setState(() {
      _title    = pTitle;
      _subTitle = pSubTitle;
    });
  }
}

class   LdAppbarCtrl 
extends LdWidgetCtrl<LdAppbarCtrl, LdAppBar> {
  // 🧩 MEMBRES ------------------------
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------  
  LdAppbarCtrl({ 
    required super.pView, 
    required super.pWidget,
    String? pTag,
  }): super(pTag: pTag?? LdTagBuilder.newCtrlTag("LdAppBarCtrl"));

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
  void onWidgetUpdated(covariant LdAppBar pOldWidget) {
    widget = pOldWidget;
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");

  }
  
  // ⚙️📍 FUNCIONALITAT ----------------
  /// Creació de tot l'arbre de components de 'LdAppbar'.
  @override
  Widget buildWidget(BuildContext pBCtx) 
    => AppBar(
        title: (widget.subTitle == null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title)
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title),
                Text(widget.subTitle!),
              ],
            ),
      actions: [],
    );
}
