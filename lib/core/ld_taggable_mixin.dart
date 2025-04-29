// ld_taggable_mixin.dart
// Mixin simplificat per a la identificació d'elements mitjançant tags
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/type_extensions.dart';

/// Mixin que proporciona capacitats d'identificació mitjançant tags únics
mixin LdTaggableMixin {
  /// Nom base de la classe.
  String get className => runtimeType.cleanClassName;

  /// Tag únic per a aquesta instància
  String? _tag;
  
  /// Obté el tag d'aquesta instància, generant-ne un si no existeix
  String get tag => _tag ?? _generateTag();
  
  /// Estableix el tag com una propietat simple
  set tag(String pNewTag) {
    _tag = pNewTag;
    Debug.info("Tag assignat: $_tag");
  }
  
  /// Genera un tag únic basat en el tipus de classe i timestamp
  String _generateTag() {
    final generatedTag = '${className}_${DateTime.now().millisecondsSinceEpoch}';
    _tag = generatedTag;
    return generatedTag;
  }
}