// L.dart
// Gestor per a l'ús de diferents llengües dins l'aplicació.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/09_intl/events/lang_changed_event.dart';

import 'ca.dart';
import 'en.dart';
import 'es.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Gestor per a l'ús de diferents llengües dins l'aplicació.
class L 
with  StreamEmitterMixin<StreamEnvelope<LdModel>, LdModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final L single = L();
  static final String className = "L";
  static final String tag = LdTagBuilder.newServiceTag(className);
  static final OnceSet<Locale> _devLocale = OnceSet<Locale>();
  static Locale? _currLocale;
  static Dict?   _currDict;

  static final LdMap<Dict> _dicts = LdMap<Dict>(pMap: {
    'ca': caMap,
    'en': enMap,
    'es': esMap,
  });
  static Dict dict = currDict();

  static const String sSabina    = "sSabina";
  static const String sAppSabina = "sAppSabina";
  static const String sWelcome   = "sWelcome";

  // 📐 FUNCIONALITAT ESTÀTICA ---------

  /// Retorna el codi de la llengua establerta en el dispositiu.
  static Locale get devLocale => _devLocale.get();     // pError: "No s'ha identificat encara la llengua per defecte del dispositiu.");
  /// Estableix (un sol cop) la llengua identificada dins el dispositiu,
  static set devLocale(Locale pLoc) => _devLocale.set(pLoc); // pError: "La llengua del dispositiu ja ha estat identificada");
  
  /// Retorna el diccionari de la llengua establerta actualment per a l'aplicació.
  static Dict currDict() {
    if (_currLocale == null) {
      _currLocale = devLocale;
      if (!_dicts.containsKey(_currLocale!.languageCode)) {
        _currLocale = Locale('es'); 
      }
      _currDict = _dicts[_currLocale!.languageCode];
    }
    return _currDict!;
  }

  /// Retorna el codi de la llengua establerta actualment per a l'aplicació.
  static Locale currLocale() {
    if (_currLocale == null) {
      _currLocale = devLocale;
      if (!_dicts.containsKey(_currLocale!.languageCode)) {
        _currLocale = Locale('es'); 
      }
      _currDict = _dicts[_currLocale!.languageCode];
    }
    return _currLocale!;
  }
  
  /// Estableix la llengua que ha de fer servir l'aplicació.
  /// Si no existeix el diccionari per a la llengua especificada s'escull per defecte l'anglès.
  static void setCurrLocale(Locale pLoc) {
    String code = pLoc.languageCode;
    if (!_dicts.containsKey(code)) {
      code = 'en';
    }
    Locale? old = L._currLocale;
    _currLocale = Locale(code);
    _currDict = _dicts[code]!;

    single.send(LangChangedEvent(
      pSrc: tag, 
      oldLocale: old,
      newLocale: _currLocale!));
  }

  /// Retorna la traducció de l'etiqueta especificada en la llengua actual.
  static String tx(String pLabel) {
    Dict curr = currDict();
    return curr[pLabel]?? "!?";
  }
}

/// Extensió d'String per a la traducció en calent de les cadenes de text.
// Extensió per a strings
extension StringL on String {
  String get tx => L.tx(this);
}