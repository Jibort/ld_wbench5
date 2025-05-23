// ld_event.dart
// Event base de l'aplicació.
// Created: 2025/05/02 dj. JIQ
// Updated: 2025/05/03 ds. CLA

import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/utils/full_set.dart';

/// Tipus d'events de l'aplicació
enum EventType {
  /// Canvi en el tema de l'aplicació
  themeChanged(0),
  /// Canvi en l'idioma de l'aplicació
  languageChanged(1),
  /// Canvi en l'estat de l'aplicació (primer pla, fons, etc.)
  applicationStateChanged(2),
  /// Reconstrucció de la UI - Aquest event s'utilitza per forçar una reconstrucció global
  rebuildUI(3),
  /// Events personalitzats
  custom(9999);

  final int idx;

  const EventType(this.idx);
}

/// Event base de l'aplicació.
class LdEvent {
  /// Tipus d'event
  final EventType eType;
  
  /// Dades associades a l'event
  final MapDyns eData;
  
  /// Tag de l'emissor de l'event
  final String? srcTag;
  
  /// Tags dels objectius de l'event (si és buit, l'event és per a tothom)
  final List<String>? tgtTags;
  
  /// Cert només quan l'event es dóna per consumit.
  final FullSet<bool> _consumed = FullSet<bool>(pInst: false);
  /// Cert només quan l'event es dóna per consumit.
  bool get isConsumed => _consumed.get()!;
  /// Estableix si l'event està consumit o no ho està.
  set isConsumed(bool pCons) => _consumed.set(pCons);

  /// Crea un nou event
  LdEvent({
    required this.eType,
    this.eData = const {},
    this.srcTag,
    this.tgtTags,
  });
  
  /// Comprova si aquest event està dirigit a un tag específic
  bool isTargetedAt(String tag) => 
    // Events globals que sempre s'han de processar
    (eType == EventType.languageChanged || 
    eType == EventType.themeChanged || 
    eType == EventType.rebuildUI) ||
    // O bé events específics per aquest tag
    (tgtTags == null || tgtTags!.isEmpty || tgtTags!.contains(tag));

  @override
  String toString() => 'LdEvent(type: ${eType.name}[${eType.idx}], source: $srcTag, targets: $tgtTags, data: $eData)';
}