// event_system.dart
// Sistema d'events simplificat
// Created: 2025/04/29

import 'dart:async';
import 'package:ld_wbench5/utils/debug.dart';

/// Tipus d'events de l'aplicació
enum EventType {
  /// Canvi en el tema de l'aplicació
  themeChanged,
  
  /// Canvi en l'idioma de l'aplicació
  languageChanged,
  
  /// Canvi en l'estat de l'aplicació (primer pla, fons, etc.)
  applicationStateChanged,
  
  /// Reconstrucció de la UI
  rebuildUI,
  
  /// Events personalitzats
  custom
}

/// Event bàsic de l'aplicació
class SabinaEvent {
  /// Tipus d'event
  final EventType type;
  
  /// Dades associades a l'event
  final Map<String, dynamic> data;
  
  /// Tag de l'emissor de l'event
  final String? sourceTag;
  
  /// Tags dels objectius de l'event (si és buit, l'event és per a tothom)
  final List<String>? targetTags;
  
  /// Crea un nou event
  SabinaEvent({
    required this.type,
    this.data = const {},
    this.sourceTag,
    this.targetTags,
  });
  
  /// Comprova si aquest event està dirigit a un tag específic
  bool isTargetedAt(String tag) => 
    targetTags == null || targetTags!.isEmpty || targetTags!.contains(tag);
    
  @override
  String toString() {
    return 'SabinaEvent(type: $type, source: $sourceTag, targets: $targetTags, data: $data)';
  }
}

/// Gestor centralitzat d'events de l'aplicació
class EventBus {
  /// Singleton
  static final EventBus _instance = EventBus._();
  
  /// Factory que retorna la instància singleton
  factory EventBus() => _instance;
  
  /// Constructor privat
  EventBus._();
  
  /// Stream controller per a emetre events
  final _controller = StreamController<SabinaEvent>.broadcast();
  
  /// Stream d'events
  Stream<SabinaEvent> get events => _controller.stream;
  
  /// Emet un event a tots els subscriptors
  void emit(SabinaEvent event) {
    if (!_controller.isClosed) {
      Debug.info("EventBus: Emetent event de tipus ${event.type}");
      _controller.add(event);
    }
  }
  
  /// Tanca el stream controller
  void dispose() {
    Debug.info("EventBus: Alliberant recursos");
    _controller.close();
  }
}