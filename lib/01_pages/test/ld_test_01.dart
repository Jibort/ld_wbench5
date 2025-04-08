// ld_test_01.dart
// Pantalla de proves número 01.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:ld_wbench5/01_pages/test/ld_test_01_ctrl.dart';
import 'package:ld_wbench5/01_pages/test/ld_test_01_model.dart';
import 'package:ld_wbench5/02_core/views/ld_view.dart';

export 'package:ld_wbench5/01_pages/test/ld_test_01_ctrl.dart';
export 'package:ld_wbench5/01_pages/test/ld_test_01_model.dart';

class LdTest01
extends LdView<LdTest01Model, LdTest01Ctrl> {
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdTest01({ 
    super.key,
    super.pTag,
    String? pTitle, 
    String? pSubTitle })
    : super(pModel: LdTest01Model(
      pTitle:    pTitle,
      pSubtitle: pSubTitle))
    { model.view = this;
      ctrl = LdTest01Ctrl(
        pView: this,
      );
    }


  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 'LdTagMixin': Retorna la base del tag de la pàgina 'LdTest01'.
  @override String baseTag() => "LdTest01";

  /// 'StatefulWidget': Creates the mutable state for this widget at a given location in the tree.
  @override
  LdTest01Ctrl createState() => ctrl;
}
