// app_event_model.dart
// Model de representació dels events que afectin el tema visual.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:flutter/material.dart';

import 'package:ld_wbench5/03_core/event/app/app_event.dart';
import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/10_tools/full_set.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

const String mfLifeCycleState = "mfLifeCycleState";
const String mfAppEventType   = "mfAppEventType";

///Enumeració dels tipus d'events d'aplicació diponibles.
enum AppEventTypeEnum {
  changeMetrics,
  changeTextScaleFactor,
  changeAppLifecycleState,
}

/// Model de representació dels events que afectin el tema visual.
class   AppEventModel 
extends LdModelAbs {
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static AppEvent envelope({
    required String pSrc,
    List<String>? pTgts, 
    required AppEventModel pModel })
  => AppEvent(pSrc: pSrc, pTgts: pTgts, pModel: pModel);

  // 🧩 MEMBRES ------------------------
  final FullSet<AppLifecycleState?> _lcState = FullSet<AppLifecycleState?>();
  final OnceSet <AppEventTypeEnum> _eType   = OnceSet<AppEventTypeEnum>();
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  AppEventModel({ required AppEventTypeEnum pEType, AppLifecycleState? pLCState }) 
  { _eType.set(pEType);
    _lcState.set(pLCState);
  }

  AppEventModel.fromMap(LdMap pMap) { fromMap(pMap); }

  // 🪟 GETTERS I SETTERS --------------
  AppLifecycleState? get lifeCycleState => _lcState.get();
  set lifeCycleState(AppLifecycleState? pLCState) => _lcState.set(pLCState);
  
  // 📍 IMPLEMENTACIÓ ABSTRACTA --------
  /// 📍 'LdModel': Retorna el tag per defecte quan aquest non s'especifica.
  @override String baseTag() => "AppEventModel";

  /// 📍 'LdModel': Reconstrueix la instància a partir d'un mapa de valors.
  @override
  void fromMap(LdMap pMap) {
    tag = pMap[mfTag];
    _eType.set(pMap[mfAppEventType]);
    _lcState.set(pMap[mfLifeCycleState]);
  } 

/// 📍 'LdModel': Retorna el mapa de valors del model.
  @override
  LdMap toMap() => LdMap(pMap: {
    mfTag:            tag,
    mfAppEventType:   _eType.get(),
    mfLifeCycleState: _lcState.get(),
  });

  /// 📍 'LdModel': Retorna el valor d'un camp del model.
  @override
  dynamic getField(String pField) 
  => (pField == mfTag)
    ? tag
    : (pField == mfAppEventType)
      ? _eType.get()
      : (pField == mfLifeCycleState)
        ? _lcState.get()
        : null;

  /// 📍 'LdModel': Retorna el nom comú del model.
  @override String modelName() => baseTag();

  /// 📍 'LdModel': Estableix el valor d'un camp del model.
  @override
  void setField(String pField, dynamic pValue) 
  => (pField == mfTag && pValue is String)
    ? tag = pValue
    : (pField == mfAppEventType && pValue is AppEventTypeEnum)
      ? _eType.set(pValue)
      : (pField == mfLifeCycleState && pValue is AppLifecycleState?)
        ? _lcState.set(pValue)
        : null;

  /// 📍 'LdModel': Retorna la cadena JSON que representa el model.
  @override String toJson() 
  => throw Exception("AppEventModel no pot ser serialitzat en JSON!");

  /// 📍 'LdModel': Reconstrueix la instància a partir d'una estructura JSON.
  @override void fromJson(String pJSon)
  => throw Exception("AppEventModel no pot ser deserialitzat des de JSON!");

}