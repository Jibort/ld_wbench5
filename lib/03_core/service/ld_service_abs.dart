// ld_service_abs.dart
// Abstracció d'un servei de l'aplicació.
// CreatedAt: 2025/04/24 dj. JIQ


import 'package:ld_wbench5/03_core/service/ld_service_intf.dart';
import 'package:ld_wbench5/03_core/tag/ld_tag_mixin.dart';

/// Abstracció d'un servei de l'aplicació.
abstract   class LdServiceAbs
with       LdTagMixin
implements LdServiceIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdServiceAbs";

  // 🧩 MEMBRES ------------------------

  // 🛠️ CONSTRUCTORS/CLEANERS ---------

  // 🪟 GETTERS I SETTERS --------------

  // 📍 MÈTODES/FUNCIONS ABSTRACTES ----

}