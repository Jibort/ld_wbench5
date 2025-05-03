// ld_event.dart
// Event base de l'aplicació.
// CreatedAt: 2025/05/02 dj. JIQ

import 'package:ld_wbench5/utils/full_set.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';

/// Tipus d'events de l'aplicació
enum EventType {
  /// Canvi en el tema de l'aplicació
  themeChanged(0),
  /// Canvi en l'idioma de l'aplicació
  languageChanged(1),
  /// Canvi en l'estat de l'aplicació (primer pla, fons, etc.)
  applicationStateChanged(2),
  /// Reconstrucció de la UI
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
  final LdMap eData;
  
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
  bool isTargetedAt(String tag)
  => (tgtTags == null || tgtTags!.isEmpty || tgtTags!.contains(tag));
    
  @override
  String toString() => 'SabinaEvent(type: ${eType.name}[${eType.idx}], source: $srcTag, targets: $tgtTags, data: $eData)';
}

