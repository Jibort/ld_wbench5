// ld_bindigs.dart
// Repositori d'instàncies 'LdTagMixin' com a dependències disponibles.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Repositori d'instàncies 'LdTagMixin' com a dependències disponibles.
class LdBindings {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdBindings";
  static final LdBindings _v = LdBindings._();

  // 📐 FUNCIONALITAT ESTÀTICA ---------
  /// Obté la instància de 'LdTagMixin' emmagatzemada amb el tag especificat
  /// des de la instància estàtica.
  static T? get<T extends LdTagMixin>(String pTag) => _v._get(pTag);

  /// Emmagatzema la instància de 'LdTagMixin' amb el tag especificat a través de la instància estàtica.
  /// Si 'pOverride' és true i ja existeix una instància amb el mateix tag, aquesta es sobreescriu.
  static set<T extends LdTagMixin>(String pTag, { required T pInst, bool pOverride = true })
    => _v._set(pTag, pInst: pInst, pOverride: pOverride); 
  
  static remove(String pTag) => _v._remove(pTag);
  static clear(pTag)         => _v._clear();

  // 🧩 MEMBRES ------------------------
  final LdMap<LdTagMixin> _map = LdMap<LdTagMixin>();

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LdBindings._();

  // ⚙️ FUNCIONALITAT -----------------
  /// Obté, si existeix, la instància de 'LdTagMixin' emmagatzemada amb el tag especificat.
  T? _get<T extends LdTagMixin>(String pTag) {
    dynamic elm = _map[pTag];
    assert(
      (elm != null && elm !is T), 
      "La instància del repositori corresponent al tag '$pTag' no correspon amb el tipus requerit (${T.runtimeType.toString()})"
    );
    
    return elm as T?;
  }

  /// Emmagatzema la instància de 'LdTagMixin' amb el tag especificat.
  /// Si 'pOverride' és true i ja existeix una instància amb el mateix tag, aquesta es sobreescriu.
  void _set<T extends LdTagMixin>(String pTag, { required T pInst, bool pOverride = true }) {
    assert(
      (pOverride || _get<T>(pTag) != null),
      "La instància amb tag '$pTag' no es pot sobreescriure!");
    _map[pTag] = pInst;
  }

  /// Elimina, si existeix, la instància de 'LdTagMixin' amb el tag especificat.
  void _remove(String pTag) =>_map.remove(pTag);

  /// Neteja el magatzem complet.
  void _clear() => _map.clear();
}
