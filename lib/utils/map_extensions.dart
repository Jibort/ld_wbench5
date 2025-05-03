// map_extensions.dart
// Extensions útils per treballar amb Maps
// Created: 2025/04/29 dt. CLA[JIQ]

/// Extensions per a mapes
extension MapExtensions<K, V> on Map<K, V> {
  /// Retorna el valor associat amb la clau o un valor per defecte
  V getOr(K key, V defaultValue) {
    return containsKey(key) ? this[key]! : defaultValue;
  }
  
  /// Retorna el valor associat amb la clau o null si no existeix
  V? getOrNull(K key) {
    return containsKey(key) ? this[key] : null;
  }
}

/// Generalització d'un mapa amb clau String i valor tipus 'T'.
typedef LdMap<T> = Map<String, T>;

/// Alias per a mapes de text a text, útil per als diccionaris
typedef Dictionary = LdMap<String>;