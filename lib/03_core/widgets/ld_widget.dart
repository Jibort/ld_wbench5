// // ld_widget.dart
// // Abstracció de tots els widgets fets servir per l'aplicació.
// // CreatedAt 2025/04/13 dl. JIQ

// import 'dart:async';
// import 'package:flutter/material.dart';


// import 'ld_widget_ctrl_abs.dart';   export 'ld_widget_ctrl_abs.dart';
// import 'ld_widget_model_abs.dart';  export 'ld_widget_model_abs.dart';
// import 'package:ld_wbench5/03_core/abstraction/ld_widget_abs.dart';
// import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
// import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';
// import 'package:ld_wbench5/03_core/views/ld_view.dart';
// import 'package:ld_wbench5/10_tools/once_set.dart';

// /// Abstracció de tots els widgets fets servir per l'aplicació.
// abstract class LdWidget<
//   T extends StreamEvent<M>, 
//   M extends LdModelAbs>
// extends    LdWidgetAbs<T, M> {
//   // 📦 MEMBRES ESTÀTICS ---------------
//   static final String className = "LdWidget";
  
//   // 🧩 MEMBRES ------------------------
//   /// Vista on pertany el wdiget.
//   final LdView _view;

//   /// Subscripció als events de l'Stream de la vista.
//   StreamSubscription<T>? _viewSub;


//   /// Subscripció als missatges de l'stream de l'aplicació.
//   StreamSubscription<T>? _appSub;

//   /// Instància del controlador del widget.
//   final OnceSet<LdWidgetCtrlAbs> _ctrl = OnceSet<LdWidgetCtrlAbs>();

//   /// Model de dades del widget.
//   final OnceSet<LdWidgetModelAbs>  _model = OnceSet<LdWidgetModelAbs>();

//   // 🛠️ CONSTRUCTORS/CLEANERS --------- 
//   LdWidget({ super.key, required LdView pView, String? pTag })
//   : _view  = pView {
//     registerTag(pTag: pTag, pInst: this);
//     _appSub  = _view.app.subscribe(this) as StreamSubscription<T>;
//     _viewSub = _view.subscribe(this) as StreamSubscription<T>;
//   }

//   /// Allibera els recursos adquirits.
//   @override
//   void dispose() {
//     view.app.unsubscribe(this);
//     view.unsubscribe(this);
//     super.dispose();
//   }

//   // 🪟 GETTERS I SETTERS --------------
//   /// Retorna la vista on pertany el widget.
//   @override LdView get view => _view;


//   /// Retorn la subscripció als events de l'Stream de la vista.
//   StreamSubscription<T>? get viewSub => _viewSub;

//   /// Retorn la subscripció als events de l'Stream de l'aplicació.
//   StreamSubscription<T>? get appSub => _appSub;

//   /// Retorna l'oïdor del widget per als events de l'Stream de l'aplicació.
  
//   /// Retorna la vista on pertany el widget.
//   @override LdWidgetCtrlAbs get wCtrl => _ctrl.get(pError: "El controlador del widget encara no s'ha assignat!");

//   /// Estableix la vista on pertany el widget.
//   @override set wCtrl(LdWidgetCtrlAbs pCtrl) => _ctrl.set(pCtrl, pError: "El controlador del widget ja estava assignat!");

//   /// Retorna el model de dades que pertany el widged.
//   @override LdWidgetModelAbs get wModel => _model.get(pError: "El model del widget encara no s'ha assignat!");

//   /// Estableix el model de dades que pertany el widged.
//   @override set wModel(LdWidgetModelAbs pModel) => _model.set(pModel, pError: "El model del widget ja estava assignat!");

//   // ⚙️📍 FUNCIONALITAT ABSTRACTA ------
//   /// Unica funcionalitat d'obligada implementació des de StatefulWidget.
//   @override State<StatefulWidget> createState() => _ctrl.get();
// }

  


