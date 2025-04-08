// routes.dart
// Declaració de les pàgines de l'aplicació.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/01_pages/test/ld_test_01.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

const rootPage = "/";

/// Declaració de les pàgines de l'aplicació.
LdMap<WidgetBuilder> pageRoutes = LdMap<WidgetBuilder>(pMap: {
  rootPage: (context) => LdTest01(),
});

