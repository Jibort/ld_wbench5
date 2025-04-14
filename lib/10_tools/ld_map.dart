// ld_map.dart
// Generalització d'un mapa amb clau String i valor tipus 'T'.
// CreatedAt: 2025/03/22 ds. JIQ

// Tipus definits sobre LdMap.
typedef Dict = LdMap<String>;
// typedef 

/// Generalització d'un mapa amb clau String i valor tipus 'T'.
class LdMap<T> 
implements Map<String, T> {
  // 🧩 MEMBRES ------------------------
  final Map<String, T> _map = {};

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdMap({ Map<String, T>? pMap }) {
    if (pMap != null) _map.addAll(pMap);
  }

  // 🪟 GETTERS I SETTERS --------------

  // 🌥️ 'Map' -------------------------
  @override T? operator [](Object? key) => _map[key];
  @override void operator []=(String key, T value) 
    => _map[key] = value;
  @override void addAll(Map<String, T> other) 
    => _map.addAll(other);
  LdMap<T> addAllAndBack(Map<String, T> other) {
    addAll(other);
    return this;
  }
  
  @override void addEntries(Iterable<MapEntry<String, T>> newEntries)
    => _map.addEntries(newEntries);
  @override Map<RK, RV> cast<RK, RV>() 
    => _map.cast<RK, RV>();
  @override void clear() 
    => _map.clear();
  @override bool containsKey(Object? key) 
    => _map.containsKey(key);
  @override bool containsValue(Object? value) 
    => _map.containsValue(value);
  @override Iterable<MapEntry<String, T>> get entries => throw UnimplementedError();
  @override void forEach(void Function(String key, T value) action) 
    => _map.forEach(action);
  @override bool get isEmpty
    => _map.isEmpty;
  @override bool get isNotEmpty 
    => _map.isNotEmpty;
  @override Iterable<String> get keys
    => _map.keys;
  @override int get length 
    => _map.length;
  @override Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(String key, T value) convert) 
    => _map.map(convert);
  @override T putIfAbsent(String key, T Function() ifAbsent) 
    => _map.putIfAbsent(key, ifAbsent);
  @override T? remove(Object? key)
    => _map.remove(key);
  @override void removeWhere(bool Function(String key, T value) test)
    => _map.removeWhere(test);
  @override T update(String key, T Function(T value) update, {T Function()? ifAbsent})
    => _map.update(key, update, ifAbsent: ifAbsent);
  @override void updateAll(T Function(String key, T value) update)
    => _map.updateAll(update);
  @override Iterable<T> get values 
    => _map.values;
} 
