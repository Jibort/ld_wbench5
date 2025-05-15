// lib/core/ld_typedefs.dart
// Tipus abreujats globals per a tota l'aplicació
// Created: 2025/05/15 dj. GPT(JIQ)

/// Generalització d'un mapa amb clau String i valor tipus 'T'.
typedef LdMap<T> = Map<String, T>;

/// Alias per a mapes de text a text, útil per als diccionaris
typedef Dictionary = LdMap<String>;

/// Alies per a llistes de texts
typedef LstStrings = List<String>;

/// Alias per a mapes de texts
typedef MapStrings = LdMap<String>;

/// Alias per a mapes dinàmics
typedef MapDyns = LdMap<dynamic>;