// ld_button.dart
// Component de botó personalitzable amb funcionalitats com:
// - Canvi d'activació/desactivació
// - Visibilitat dinàmica
// - Mode principal/secundari amb estils diferenciats
// - Icona opcional a l'esquerra del text
// CreatedAt: 2025/04/14 dg. CLA[JIQ]

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_ctrl.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_model.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Model de dades del widget LdButton.
class   LdButtonModel 
extends LdWidgetModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdButtonModel";
  
  // 🧩 MEMBRES ------------------------
  final String text;
  final bool isPrimary;
  final VoidCallback? onPressed;
  final IconData? leftIcon;
  final double? width;
  final double? height;
  final double elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? primaryColor;
  final Color? primaryTextColor;
  final Color? secondaryColor;
  final Color? secondaryTextColor;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final TextStyle? textStyle;
  final bool expanded;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  LdButtonModel({
    super.isEnabled   = true,
    super.isVisible   = true,
    super.isFocusable = false,
    this.isPrimary    = true,
    required this.text,
    this.onPressed,
    this.leftIcon,
    this.width,
    this.height = 48.0,
    this.elevation = 0.0,
    this.borderRadius,
    EdgeInsetsGeometry? pPadding,
    this.primaryColor,
    this.primaryTextColor,
    this.secondaryColor,
    this.secondaryTextColor,
    this.disabledColor,
    this.disabledTextColor,
    this.textStyle,
    this.expanded = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center, })
    : padding = pPadding ?? EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h);

  @override
  LdMap toMap() => super.toMap().addAllAndBack({
    mfIsPrimary: isPrimary,
  });

  LdButtonModel copyWith({
    bool? isEnabled, bool? isVisible, bool? isFocusable, bool? isPrimary,
    String? text,
    VoidCallback? onPressed,
    IconData? leftIcon,
    double? width, double? height, double? elevation,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    Color? primaryColor, Color? primaryTextColor, Color? secondaryColor,
    Color? secondaryTextColor, Color? disabledColor, Color? disabledTextColor,
    TextStyle? textStyle,
    bool? expanded,
    MainAxisSize? mainAxisSize, MainAxisAlignment? mainAxisAlignment, CrossAxisAlignment? crossAxisAlignment,
  }) {
    return LdButtonModel(
      isEnabled:          isEnabled ??          this.isEnabled,
      isVisible:          isVisible ??          this.isVisible,
      isFocusable:        isFocusable ??        this.isFocusable,
      isPrimary:          isPrimary ??          this.isPrimary,
      text:               text ??               this.text,
      onPressed:          onPressed ??          this.onPressed,
      leftIcon:           leftIcon ??           this.leftIcon,
      width:              width ??              this.width,
      height:             height ??             this.height,
      elevation:          elevation ??          this.elevation,
      borderRadius:       borderRadius ??       this.borderRadius,
      padding:            padding ??            this.padding,
      primaryColor:       primaryColor ??       this.primaryColor,
      primaryTextColor:   primaryTextColor ??   this.primaryTextColor,
      secondaryColor:     secondaryColor ??     this.secondaryColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      disabledColor:      disabledColor ??      this.disabledColor,
      disabledTextColor:  disabledTextColor ??  this.disabledTextColor,
      textStyle:          textStyle ??          this.textStyle,
      expanded:           expanded ??           this.expanded,
      mainAxisSize:       mainAxisSize ??       this.mainAxisSize,
      mainAxisAlignment:  mainAxisAlignment ??  this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
    );
  }
  
  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  // 📍 'LdTagMixin': Retorna el tab base per defecte de la classe.
  @override String baseTag() => LdButtonModel.className;
  
  /// 'LdModel': Retorna la representació de la instància com a estructura en String.
  @override
  String toStr({int pLevel = 0}) {
    String root = ' ' * pLevel * 2;
    String body = ' ' * (pLevel + 1) * 2;
    
    return """
$root[
$body'$mfTitle':    ${super.title},
$body'$mfSubTitle': ${super.subTitle},
$root]
""";
  }

  /// Retorna el valor d'un component donat o null.
  @override
  dynamic getField(String pField) {}

  /// Estableix el valor d'un component donat del model.
  @override
  void setField(String pField, dynamic pValue);

}

/// 📱 LdButton 
/// 
/// Component de botó personalitzable amb funcionalitats com:
/// - Canvi d'activació/desactivació
/// - Visibilitat dinàmica
/// - Mode principal/secundari amb estils diferenciats
/// - Icona opcional a l'esquerra del text
class LdButton 
extends LdWidget<LdButtonCtrl, LdButton, LdButtonModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdButton";
  static final String _buttonTag = LdTagBuilder.newWidgetTag(LdButton.className);
  
  // 🧩 MEMBRES ------------------------
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdButton({
    required super.key, 
    required super.pView,
    String? pTag,
    bool isEnabled   = true,
    bool isVisible   = true,
    bool isFocusable = true,
    required String text,
    this.onPressed,
    this.leftIcon,
    this.width,
    this.height = 48.0,
    this.elevation = 0.0,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.primaryColor,
    this.primaryTextColor,
    this.secondaryColor,
    this.secondaryTextColor,
    this.disabledColor,
    this.disabledTextColor,
    this.textStyle,
    this.expanded = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center, })
  : super(
    pTag: pTag?? _buttonTag,
    pModel: LdButtonModel(
      pTitle: pTitle, 
      pSubTitle: pSubTitle
    )
  );

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdAppBar.className;

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override LdWidgetCtrl<LdButtonCtrl, LdButton, LdButtonModel> createState() => wCtrl;

}

/// 🎮 Controlador per al LdButton
class LdButtonCtrl extends LdWidgetCtrl<LdButtonCtrl, LdButton, LdButtonModel> {
  // 🛠️ INIT/CLEANERS -----------------
  @override
  void initState() {
    super.initState();
    model = LdButtonModel(
      enabled: widget.enabled,
      visible: widget.visible,
      isPrimary: widget.isPrimary,
    );
  }

  @override
  void didUpdateWidget(LdButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualitzar el model si canvien les propietats
    if (widget.enabled != oldWidget.enabled) {
      setEnabled(widget.enabled);
    }
    if (widget.visible != oldWidget.visible) {
      setVisible(widget.visible);
    }
    if (widget.isPrimary != oldWidget.isPrimary) {
      setIsPrimary(widget.isPrimary);
    }
  }

  // ⚙️ FUNCIONALITAT -----------------
  void setEnabled(bool value) {
    updateModel(model.copyWith(enabled: value));
  }

  void setVisible(bool value) {
    updateModel(model.copyWith(visible: value));
  }

  void setIsPrimary(bool value) {
    updateModel(model.copyWith(isPrimary: value));
  }

  // Sobrescrivim això dels Streams per si tenim algun listener en el futur
  @override
  void _setupListeners() {
    // Encara no hi ha listeners
  }

  @override
  void listened(StreamEnvelope<LdModel> pEnvelope) {
    // Implementació futura
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    debugPrint("Error a LdButton: $error");
  }

  @override
  void onDone() {
    debugPrint("Stream tancat per LdButton");
  }

  @override
  Widget build(BuildContext context) {
    if (!model.visible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    
    // Colors per defecte basats en el tema
    final defaultPrimaryColor = widget.primaryColor ?? theme.primaryColor;
    final defaultPrimaryTextColor = widget.primaryTextColor ?? theme.primaryTextTheme.labelLarge?.color ?? Colors.white;
    final defaultSecondaryColor = widget.secondaryColor ?? Colors.transparent;
    final defaultSecondaryTextColor = widget.secondaryTextColor ?? theme.primaryColor;
    final defaultDisabledColor = widget.disabledColor ?? theme.disabledColor.withOpacity(0.2);
    final defaultDisabledTextColor = widget.disabledTextColor ?? theme.disabledColor;

    // Determinem colors basats en l'estat
    final Color backgroundColor = model.enabled
        ? (model.isPrimary ? defaultPrimaryColor : defaultSecondaryColor)
        : defaultDisabledColor;
    
    final Color textColor = model.enabled
        ? (model.isPrimary ? defaultPrimaryTextColor : defaultSecondaryTextColor)
        : defaultDisabledTextColor;
    
    // Determinem l'estil del text
    final TextStyle effectiveTextStyle = (widget.textStyle ?? theme.textTheme.labelLarge ?? const TextStyle())
        .copyWith(color: textColor);

    // Construïm el contingut del botó
    Widget buttonContent = Row(
      mainAxisSize: widget.mainAxisSize,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        if (widget.leftIcon != null) ...[
          Icon(widget.leftIcon, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.text,
            style: effectiveTextStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    // Construïm el botó
    final buttonStyle = ElevatedButton.styleFrom(
      elevation: widget.elevation,
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      disabledBackgroundColor: defaultDisabledColor,
      disabledForegroundColor: defaultDisabledTextColor,
      padding: widget.padding,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        side: model.isPrimary ? BorderSide.none : BorderSide(color: defaultPrimaryColor),
      ),
      minimumSize: Size(widget.width ?? 0, widget.height ?? 48),
      maximumSize: widget.expanded 
          ? const Size(double.infinity, double.infinity)
          : null,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
    );

    // Botó final
    Widget button = ElevatedButton(
      onPressed: model.enabled ? widget.onPressed : null,
      style: buttonStyle,
      focusNode: FocusNode(canRequestFocus: false, skipTraversal: true),
      child: buttonContent,
    );

    // Apliquem el width si és necessari
    if (widget.width != null) {
      button = SizedBox(width: widget.width, child: button);
    }

    // Si és expanded, el fem ocupar tot l'espai disponible
    if (widget.expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}