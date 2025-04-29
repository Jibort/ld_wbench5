// // ld_view.dart
// // Abstracció d'una pàgina de l'aplicació.
// // La V de Model-View-Control.
// // CreatedAt: 2025/04/07 dl. JIQ

// import 'dart:async';

// import 'package:ld_wbench5/03_core/app/sabina_app.dart';
// import 'package:ld_wbench5/03_core/abstraction/ld_view_abs.dart';
// import 'package:ld_wbench5/10_tools/once_set.dart';
// import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
// import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';
// import 'ld_view_ctrl_abs.dart';
// import 'ld_view_model_abs.dart';

// export 'ld_view_ctrl_abs.dart';
// export 'ld_view_model_abs.dart';

// /// Abstracció d'una pàgina de l'aplicació.
// abstract class LdView<
//   T extends StreamEvent<M>, 
//   M extends LdModelAbs>
// extends LdViewAbs<T, M> {
//   // 📦 MEMBRES ESTÀTICS ---------------
//   static final String className = "LdView";
  
//   // 🧩 MEMBRES ------------------------
//   /// Aplicació on pertany la vista.
//   final OnceSet<SabinaApp> _app = OnceSet<SabinaApp>();

//   /// Subscripció als missatges de l'stream de l'aplicació.
//   StreamSubscription<T>? _appSub;

//   /// Model de la vista.
//   final OnceSet<LdViewModelAbs> _model = OnceSet<LdViewModelAbs>();
  
//   /// Controlador de la vista.
//   final OnceSet<LdViewCtrlAbs> _ctrl = OnceSet<LdViewCtrlAbs>();

//   // 🛠️ CONSTRUCTORS/CLEANERS --------- 
//   LdView({ 
//     super.key,
//     String? pTag,
//     required SabinaApp pApp }) 
//   { _app.set(pApp);
//     registerTag(pTag: pTag, pInst: this);
//     _appSub = _app.get().subscribeToEmitter(this, this);
//   }

//   /// Allibera els recursos adquirits.
//   @override
//   void dispose() {
//     if (_appSub != null) {
//       _app.get().unsubscribe(this);
//     }
//     super.dispose();
//   }

//   // 🪟 GETTERS I SETTERS --------------
//   /// 📍 'LdViewIntf': Retorna la instància de l'aplicació on pertany la vista.
//   @override SabinaApp get app => _app.get();

//   /// 📍 'LdViewIntf': Estableix la instància de l'aplicació on pertany la vista.
//   @override set app(SabinaApp pApp) => _app.set(pApp);

//   /// 📍 'LdViewIntf': Retorna l'oidor d'stream de la vista.
//   @override StreamSubscription<T>? get appSub => _appSub;

//   /// 📍 'LdViewIntf': Estableix l'oidor d'stream de la vista.
//   @override set appSub(StreamSubscription<T>? pAppSub) => _appSub = pAppSub;	

//   /// 📍 'LdViewIntf': Retorna el model de la vista.
//   @override LdViewModelAbs get vModel => _model.get();       // pError: "El model de la vista $tag encara no ha estat assignat!");

//   /// 📍 'LdViewIntf': Estableix el model de la vista.
//   @override set vModel(LdViewModelAbs pModel) => _model.set(pModel); // pError: "El model de la vista $tag ja ha estat assignat!");

//   /// 📍 'LdViewIntf': Retorna el controlador de la vista.
//   @override LdViewCtrlAbs get vCtrl => _ctrl.get();         // pError: "El controlador de la vista $tag encara no ha estat assignat!");

//   /// 📍 'LdViewIntf': Estableix el controlador de la vista.
//   @override set vCtrl(LdViewCtrlAbs pCtrl) => _ctrl.set(pCtrl);    // pError: "El controlador de la vista $tag ja ha estat assignat!");
// }
