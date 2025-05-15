// main.dart
// Entrada principal a l'aplicació 'Sabina'.
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';
import 'package:ld_wbench5/services/global_variables_service.dart';

import 'package:ld_wbench5/ui/app/sabina_app.dart';
import 'package:ld_wbench5/utils/debug.dart';

void main() {
  // Assegura que l'arquitectura de Widgets està inicialitzada.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Assegura que l'arquitectura de variables globals està inicialitzada.
  GlobalVariablesService.initialize();

  Debug.info("Iniciant aplicació Sabina...");
  
  // Activar tots els nivells de debug en desenvolupament
  Debug.activateAllLevels();
  
  // Iniciar l'aplicació
  runApp(SabinaApp.s);
}