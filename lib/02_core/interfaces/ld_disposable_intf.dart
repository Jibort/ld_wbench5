// ld_disposable_intf.dart
// Interfície per a les classes que requereixen de la implementació 
// del mètode 'dispose()'.
// CreatedAt: 2025/04/13 dl. JIQ

abstract class LdDisposableIntf {
  /// Allibera qualsevol recurs que hagi estat assignat a la instància.
  void dispose();
}