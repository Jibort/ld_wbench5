// ld_view_model.dart
// Abstracció del model de dades per a una pàgina de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/10_tools/only_once.dart';

/// Abstracció del controlador per a una pàgina de l'aplicació.
abstract class LdViewModel 
extends  LdModel {
  // 🧩 MEMBRES ------------------------
  final OnlyOnce<LdView> _view = OnlyOnce<LdView>();
  late String  _title;
  late String? _subTitle;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdViewModel({ 
    // required LdView pView, 
    super.pTag,
    required String pTitle, 
    String? pSubTitle })
  : // _view = pView,
    _title = pTitle,
    _subTitle = pSubTitle;

  @override
  void dispose() {
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  LdView  get view     => _view.get();
  String  get title    => _title;
  String? get subTitle => _subTitle;

  set view(LdView pView)
    => _view.set(pView, pError: "Error en assignació 'LdViewModel'!");

  set title(String pTitle) {
    view.ctrl.setState(() => _title = pTitle);
  }
  
  set subtitle(String? pSubTitle) {
    view.ctrl.setState(() => _subTitle = pSubTitle);
  }
}

