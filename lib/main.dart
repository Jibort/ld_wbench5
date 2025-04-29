// main.dart
// Entrada principal a l'aplicació 'Sabina'.
// CreatedAt: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';

import 'package:ld_wbench5/ui/app.dart';
import 'package:ld_wbench5/utils/debug.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  Debug.info("Iniciant aplicació Sabina...");
  
  // Activar tots els nivells de debug en desenvolupament
  Debug.activateAllLevels();
  
  // Iniciar l'aplicació
  runApp(SabinaApp.instance);
}