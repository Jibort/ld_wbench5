// ld_disposable_intf.dart
// Interfície per a les classes que requereixen de la implementació 
// del mètode 'dispose()'.
// CreatedAt: 2025/04/15 dt. JIQ

/// Interfície per a les classes que requereixen de la implementació 
abstract class LdDisposableIntf {
  /// Allibera qualsevol recurs que hagi estat assignat a la instància.
  void dispose();
}