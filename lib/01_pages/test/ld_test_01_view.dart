// ld_test_01_view.dart
// Pantalla de proves número 01.
// CreatedAt: 2025/04/08 dt. JIQ

import 'ld_test_01_ctrl.dart';
import 'ld_test_01_model.dart';
import 'package:ld_wbench5/03_core/event/app/app_event.dart';
import 'package:ld_wbench5/03_core/tag/ld_tag_intf.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_view_abs.dart';

export 'ld_test_01_ctrl.dart';
export 'ld_test_01_model.dart';

class   LdTest01View
extends LdViewAbs
implements LdTagIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdTest01";
  
  // 🧩 MEMBRES ------------------------

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdTest01View({ 
    super.key,
    required super.pApp,
    super.pTag,
    String? pTitle, 
    String? pSubTitle })
  { vModel = LdTest01Model(
      pView:     this,
      pTitle:    pTitle,
      pSubtitle: pSubTitle
    );
    vCtrl = LdTest01Ctrl(
      pView: this
    );
  }

  // 🪟 GETTERS I SETTERS --------------
  
  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 'LdTagMixin': Retorna la base del tag de la pàgina 'LdTest01'.
  @override String baseTag() => LdTest01View.className;

  /// 'StatefulWidget': Retorna el controlador 'State' de la vista.
  @override
  LdTest01Ctrl createState() => vCtrl as LdTest01Ctrl;

  // ⚙️📍 'LdStreamListenerIntf' ===============================================
  /// Gestió dels events de l'apicació.
  @override listenAppEvent(AppEvent pEnv) {
    // TODO: Cal gestionar events d'aplicació des d'una vista final?
  }

  /// Gestió dels errors a l'Stream del gestor d'idiomes.
  @override onAppStreamError(Object pError, StackTrace pTrace) {
    // TODO: Cal gestionar events d'aplicació des d'una vista final?
  }

  @override onAppStreamDone() {
    // TODO: Cal gestionar events d'aplicació des d'una vista final?
  }
}
