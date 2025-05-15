// ld_widget_ctrl_abs.dart
// Controlador del Widget base per a l'aplicació.
// Amb gestió de visibilitat, focus i estat actiu.
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA
// Updated: 2025/05/11 ds. CLA - Afegit getter públic per al model
// Updated: 2025/05/11 ds. CLA - Optimització amb gestió de model i GlobalKey

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_model_abs.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador base pels widgets.
abstract   class LdWidgetCtrlAbs<T extends LdWidgetAbs>
extends    State<T>
with       LdTaggableMixin
implements LdLifecycleIntf, LdModelObserverIntf {
  /// Model del widget
  LdWidgetModelAbs? _model;
  
  /// Getter públic per accedir al model
  LdWidgetModelAbs? get model => _model;
  
  /// Setter per assignar el model
  @protected
  set model(LdWidgetModelAbs? newModel) {
    if (_model != newModel) {
      // Desregistrar-se de l'antic model si existeix
      if (_model != null) {
        _model!.detachObserver(this);
      }
      
      // Assignar el nou model
      _model = newModel;
      
      // Registrar-se com a observador del nou model
      if (_model != null) {
        _model!.attachObserver(this);
      }
      
      Debug.info("$tag: Model actualitzat");
    }
  }
  
  /// Retorna el widget associat al controlador amb el tipus correcte.
  T get cWidget => widget;
  
  /// Subscripció als events de l'aplicació
  StreamSubscription<LdEvent>? _subcEvent;
  
  /// PROPIETATS DE VISUALITZACIÓ I INTERACCIÓ ===================================
  /// Flag de visibilitat del widget
  bool _isVisible = true;
  
  /// Retorna si el widget és visible
  bool get isVisible => _isVisible;
  
  /// Estableix si el widget és visible i reconstrueix la UI si és necessari
  set isVisible(bool value) {
    if (_isVisible != value && mounted) {
      setState(() {
        _isVisible = value;
        Debug.info("$tag: Visibilitat canviada a $value");
      });
    } else if (_isVisible != value) {
      // Si no està muntat, només canviem el valor
      _isVisible = value;
      Debug.info("$tag: Visibilitat canviada a $value (sense reconstrucció)");
    }
  }

  /// Node de focus pel widget
  final FocusNode _focusNode = FocusNode();
  
  /// Retorna el node de focus del widget
  FocusNode get focusNode => _focusNode;
  
  /// Indica si el widget té el focus
  bool get hasFocus => _focusNode.hasFocus;
  
  /// Flag que indica si el widget pot rebre focus
  bool _canFocus = true;
  
  /// Retorna si el widget pot rebre focus
  bool get canFocus => _canFocus;
  
  /// Estableix si el widget pot rebre focus i reconstrueix la UI si és necessari
  set canFocus(bool value) {
    if (_canFocus != value && mounted) {
      setState(() {
        _canFocus = value;
        if (!value && hasFocus) {
          _focusNode.unfocus();
        }
        Debug.info("$tag: Capacitat de focus canviada a $value");
      });
    } else if (_canFocus != value) {
      // Si no està muntat, només canviem el valor
      _canFocus = value;
      if (!value && hasFocus) {
        _focusNode.unfocus();
      }
      Debug.info("$tag: Capacitat de focus canviada a $value (sense reconstrucció)");
    }
  }
  
  /// Flag que indica si el widget està actiu (enabled)
  bool _isEnabled = true;
  
  /// Retorna si el widget està actiu
  bool get isEnabled => _isEnabled;
  
  /// Estableix si el widget està actiu i reconstrueix la UI si és necessari
  set isEnabled(bool value) {
    if (_isEnabled != value && mounted) {
      setState(() {
        _isEnabled = value;
        if (!value && hasFocus) {
          _focusNode.unfocus();
        }
        Debug.info("$tag: Estat d'activació canviat a $value");
      });
    } else if (_isEnabled != value) {
      // Si no està muntat, només canviem el valor
      _isEnabled = value;
      if (!value && hasFocus) {
        _focusNode.unfocus();
      }
      Debug.info("$tag: Estat d'activació canviat a $value (sense reconstrucció)");
    }
  }
  
  /// Demana focus per aquest widget si pot rebre'l i està actiu
  void requestFocus() {
    if (canFocus && isEnabled && isVisible) {
      _focusNode.requestFocus();
      Debug.info("$tag: Focus demanat");
    }
  }
  
  /// Configura l'estat del widget (visible, focus, enabled) i reconstrueix la UI
  void setWidgetState({
    bool? visible,
    bool? canFocus,
    bool? enabled,
  }) {
    bool needsUpdate = false;
    
    if (visible != null && _isVisible != visible) {
      _isVisible = visible;
      needsUpdate = true;
    }
    
    if (canFocus != null && _canFocus != canFocus) {
      _canFocus = canFocus;
      if (!canFocus && hasFocus) {
        _focusNode.unfocus();
      }
      needsUpdate = true;
    }
    
    if (enabled != null && _isEnabled != enabled) {
      _isEnabled = enabled;
      if (!enabled && hasFocus) {
        _focusNode.unfocus();
      }
      needsUpdate = true;
    }
    
    if (needsUpdate && mounted) {
      setState(() {
        Debug.info("$tag: Estat del widget actualitzat");
      });
    } else if (needsUpdate) {
      Debug.info("$tag: Estat del widget actualitzat (sense reconstrucció)");
    }
  }
  
  /// Toggle per canviar la visibilitat
  void toggleVisibility() {
    Debug.info("$tag: Cridant a toggleVisibility()");
    if (mounted) {
      setState(() {
        _isVisible = !_isVisible;
        Debug.info("$tag: Visibilitat alternada a $_isVisible");
      });
    } else {
      _isVisible = !_isVisible;
      Debug.info("$tag: Visibilitat alternada a $_isVisible (sense reconstrucció)");
    }
  }
  
  /// Toggle per canviar l'estat actiu
  void toggleEnabled() {
    Debug.info("$tag: Cridant a toggleEnabled()");
    if (mounted) {
      setState(() {
        _isEnabled = !_isEnabled;
        Debug.info("$tag: Estat d'activació alternat a $_isEnabled");
      });
    } else {
      _isEnabled = !_isEnabled;
      Debug.info("$tag: Estat d'activació alternat a $_isEnabled (sense reconstrucció)");
    }
  }
  
  /// CONSTRUCTOR ---------------------
  LdWidgetCtrlAbs(T pWidget, {
    bool isVisible = true,
    bool canFocus = true,
    bool isEnabled = true
  }) {
    // Assignem els valors directament sense cridar setState
    _isVisible = isVisible;
    _canFocus = canFocus;
    _isEnabled = isEnabled;
    
    // Configurar listener de focus per debugging
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Debug.info("$tag: Ha rebut el focus");
      } else {
        Debug.info("$tag: Ha perdut el focus");
      }
    });
  }

  /// Inicialitza el controlador
  @override
  void initState() {
    super.initState();
    tag = '${widget.tag}_Ctrl';
    _subcEvent = EventBus.s.listen(_handleEvent);
    
    // Carregar configuració del widget
    _loadConfigFromWidget();
    
    // Crear el model si el widget ho requereix
    _createModelIfNeeded();
    
    initialize();
    Debug.info("$tag: Controlador inicialitzat");
  }
  
  /// Carrega la configuració des del widget
  void _loadConfigFromWidget() {
    final config = widget.config;
    
    // Carregar propietats del controlador
    _isVisible = config[cfIsVisible] as bool? ?? true;
    _canFocus = config[cfCanFocus] as bool? ?? true;
    _isEnabled = config[cfIsEnabled] as bool? ?? true;
    
    Debug.info("$tag: Configuració carregada: visible=$_isVisible, canFocus=$_canFocus, enabled=$_isEnabled");
  }
  
  /// Crea el model del widget si és necessari
  /// Aquest mètode ha de ser sobreescrit per les subclasses per crear un model específic
  @protected
  void _createModelIfNeeded() {
    // Implementació base buida
    // Les subclasses haurien de sobreescriure aquest mètode per crear el seu model específic
  }
  
  /// Processa un event rebut
  void _handleEvent(LdEvent event) {
    // Processar events globals o dirigits a aquest controlador
    if (event.eType == EventType.languageChanged || 
        event.eType == EventType.themeChanged || 
        event.eType == EventType.rebuildUI || 
        event.isTargetedAt(tag)) {
      Debug.info("$tag: Processant event ${event.eType.name}");
      onEvent(event);
    }
  }
  
  /// Mètode a sobreescriure per gestionar events
  void onEvent(LdEvent event);
  
  /// Actualitza el controlador quan canvien les dependències
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Debug.info("$tag: Dependències actualitzades");
    update();
  }
  
  /// Gestiona l'actualització del widget quan canvien les propietats
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Verificar si la configuració ha canviat
    if (_hasConfigChanged(oldWidget)) {
      Debug.info("$tag: Configuració actualitzada, recarregant");
      _loadConfigFromWidget();
      
      // Forçar reconstrucció si és necessari
      setState(() {
        // Reconstruir la UI
      });
    }
  }
  
  /// Comprova si la configuració ha canviat
  bool _hasConfigChanged(T oldWidget) {
    // Comparar només les propietats del controlador (cf*)
    final oldConfig = oldWidget.config;
    final newConfig = widget.config;
    
    // Filtrar i comparar només les propietats de controlador (cf*)
    bool hasChanged = false;
    for (final key in newConfig.keys) {
      if (key.startsWith('cf') && key != cfTag) {
        if (oldConfig[key] != newConfig[key]) {
          Debug.info("$tag: Canvi detectat en propietat $key: ${oldConfig[key]} -> ${newConfig[key]}");
          hasChanged = true;
          break;
        }
      }
    }
    
    return hasChanged;
  }
  
  /// Allibera els recursos
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos del controlador...");
    
    // Cridar cleanup del widget per alliberar el mapa
    widget.cleanup();
    
    // Cancelar subscripció a events
    EventBus.s.cancel(_subcEvent);
    
    // Alliberar recursos del node de focus
    _focusNode.dispose();
    
    // Desregistrar-se del model
    if (_model != null) {
      _model!.detachObserver(this);
      _model = null;
    }
    
    super.dispose();
    Debug.info("$tag: Recursos del controlador alliberats");
  }
  
  /// Notificació de canvi en un model
  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    Debug.info("$tag: Model ha canviat");
    
    // Executar la funció d'actualització
    pfUpdate();
    
    // Reconstruir si està muntat
    if (mounted) {
      setState(() {
        Debug.info("$tag: Reconstruint després del canvi del model");
      });
    }
  }
  
  /// Construeix el widget
  @override
  Widget build(BuildContext context) {
    Debug.info("$tag: Construint widget. isVisible=$_isVisible");
    
    // Si el widget no és visible, retornem un SizedBox buit
    if (!_isVisible) {
      return const SizedBox.shrink();
    }
    
    // Construïm el contingut del widget
    Widget content = buildContent(context);
    
    // Apliquem l'opacitat i l'absorció d'events si el widget no està actiu
    if (!_isEnabled) {
      content = Opacity(
        opacity: 0.5,
        child: AbsorbPointer(
          absorbing: true,
          child: content,
        ),
      );
    }
    
    return content;
  }
  
  /// Mètode que ha d'implementar cada widget per construir la seva UI
  Widget buildContent(BuildContext context);
  
  /// Passarel·la de pas per a la crida a setState().
  @override setState(void Function() pFN) {
    super.setState(pFN);
  }
}