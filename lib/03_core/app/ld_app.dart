// ld_app.dart
// Generalització del widget principal de l'aplicació.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/09_intl/L.dart';
import 'package:ld_wbench5/routes.dart';

/// Generalització del widget principal de l'aplicació.
abstract class LdApp
extends  StatelessWidget {

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  const LdApp({super.key});

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