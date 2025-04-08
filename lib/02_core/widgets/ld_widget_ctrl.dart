// ld_widget_ctrl.dart
// Abstracció del controlador per a un widget de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/02_core/ld_ctrl.dart';
import 'package:ld_wbench5/02_core/widgets/ld_widget.dart';

/// Abstracció del controlador per a un widget de l'aplicació.
abstract class LdWidgetCtrl 
extends  LdCtrl {
  // 🧩 MEMBRES ------------------------
  final LdWidget _widget;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdWidgetCtrl({ required LdWidget pWidget })
  : _widget = pWidget;

  @override
  void dispose() {
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  @override
  LdWidget get widget => _widget;
}
