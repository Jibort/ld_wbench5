// ld_app.dart
// Generalització del widget principal de l'aplicació.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/09_intl/L.dart';
import 'package:ld_wbench5/routes.dart';

/// Generalització del widget principal de l'aplicació.
class   SabinaApp
extends StatelessWidget
with    StreamEmitterMixin<StreamEnvelope<LdModel>, LdModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "SabinaApp";
  static SabinaApp? _inst;

  // 📐 FUNCIONALITAT ESTÀTICA ---------
  /// Retorna la instància singleton del widget aplicació.
  static SabinaApp get inst {  
  _inst ??= SabinaApp._();
    return _inst!;
  }

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor fosc i unic de l'aplicació.
  SabinaApp._() {
    WidgetsFlutterBinding.ensureInitialized();
    L.devLocale = WidgetsBinding.instance.platformDispatcher.locale;
  }

  // ♻️ CLICLE DE VIDA ----------------
  @override
  Widget build(BuildContext pBCtx) {
    return MaterialApp(
      title: L.sSabina.tx,
      debugShowCheckedModeBanner: false,
      routes: pageRoutes,
      initialRoute: rootPage,
    );
  }

}