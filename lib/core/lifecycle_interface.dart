// lifecycle_interface.dart
// Interfície simplificada per al cicle de vida dels components
// Created: 2025/04/29 dt. CLA[JIQ]

/// Interfície que defineix els mètodes bàsics del cicle de vida dels components
abstract class LdLifecycleIntf {
  /// Cridat quan el component s'inicialitza
  /// Equivalent a initState en StatefulWidget
  void initialize();
  
  /// Cridat quan canvien les dependències o es necessita una actualització
  /// Equivalent a didChangeDependencies en StatefulWidget
  void update();
  
  /// Cridat quan el component es destrueix
  /// Equivalent a dispose en StatefulWidget
  void dispose();
}