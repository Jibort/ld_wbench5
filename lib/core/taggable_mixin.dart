// taggable_mixin.dart
// Mixin simplificat per a la identificació d'elements mitjançant tags
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/foundation.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Mixin que proporciona capacitats d'identificació mitjançant tags únics
mixin LdTaggable {
  /// Tag únic per a aquesta instància
  String? _tag;
  
  /// Obté el tag d'aquesta instància, generant-ne un si no existeix
  String get tag => _tag ?? _generateTag();
  
  /// Estableix un tag personalitzat per a aquesta instància
  @mustCallSuper
  void setTag(String newTag) {
    _tag = newTag;
    // Registrar el tag si cal en un sistema centralitzat
    Debug.info("Tag assignat: $_tag");
  }
  
  /// Genera un tag únic basat en el tipus de classe i timestamp
  String _generateTag() {
    final generatedTag = '${runtimeType.toString()}_${DateTime.now().millisecondsSinceEpoch}';
    _tag = generatedTag;
    return generatedTag;
  }
}