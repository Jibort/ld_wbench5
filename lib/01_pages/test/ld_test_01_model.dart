// ld_test_01_model.dart
// Model de dades per a la pàgina de proves 'LdTest01'.
// CreatedAt: 2025/02/08 dt. JIQ

import 'package:ld_wbench5/03_core/views/ld_view_model.dart';
import 'package:ld_wbench5/09_intl/L.dart';

/// Model de dades per a la pàgina de proves 'LdTest01'.
class   LdTest01Model
extends LdViewModel {
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdTest01Model({
    super.pTag,
    String? pTitle,
    String? pSubtitle})
  : super(
      pTitle:    pTitle??    L.sAppSabina.tx, 
      pSubTitle: pSubtitle?? L.sWelcome.tx
    );

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 'LdTagMixin': Retorna la base del model de la pàgina 'LdTest01'.
  @override String baseTag() => "LdTest01Model";
}