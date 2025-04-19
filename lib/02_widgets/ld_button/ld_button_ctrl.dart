// ld_button_ctrl.dart
// Controlador del widget  'LdButton'.
// CreatedAt: 2025/04/18 dv. JIQ

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ld_wbench5/02_widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/02_widgets/ld_button/ld_button_model.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/conversions.dart';

/// Controlador del widget  'LdButton'.
/// 🎮 Controlador per al LdButton
class   LdButtonCtrl 
extends LdWidgetCtrl<LdButton> {
  // 🧩 MEMBRES ------------------------
        bool               isPrimary;
  final VoidCallback?      onPressed;
  final IconData?          leftIcon;
  final double?            width;
  final double?            height;
  final double             elevation;
  final BorderRadius?      borderRadius;
  final EdgeInsetsGeometry padding;
  final Color?             primaryColor;
  final Color?             primaryTextColor;
  final Color?             secondaryColor;
  final Color?             secondaryTextColor;
  final Color?             disabledColor;
  final Color?             disabledTextColor;
  final TextStyle?         textStyle = null;
  final bool               expanded;
  final MainAxisSize       mainAxisSize;
  final MainAxisAlignment  mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdButtonCtrl({
    required super.pView, 
    required super.pWidget,
    super.pTag,
    super.isEnabled,
    super.isVisible,
    super.isFocusable,
    this.isPrimary = true,
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
    TextStyle? pTextStyle,
    this.expanded = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center })
    : padding = pPadding ?? EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h);
    
  // 🪟 GETTERS I SETTERS --------------
  @override LdButton get widget => super.widget;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(LdButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualitzar el model si canvien les propietats
    if (isEnabled != oldWidget.wCtrl.isEnabled) {
      setEnabled(oldWidget.wCtrl.isEnabled = isEnabled);
    }
    if (widget.wCtrl.isVisible != oldWidget.wCtrl.isVisible) {
      setVisible(widget.wCtrl.isVisible);
    }
    if ((widget.wCtrl as LdButtonCtrl).isPrimary != (oldWidget.wCtrl as LdButtonCtrl).isPrimary) {
      setIsPrimary((widget.wCtrl as LdButtonCtrl).isPrimary);
    }
  }

  // ⚙️ FUNCIONALITAT -----------------
  void setEnabled(bool pValue) {
    if (isEnabled != pValue) {
      setState(() => isEnabled  = pValue);
    }
  }

  void setVisible(bool pValue) {
    if (isVisible != pValue) {
      setState(() => isVisible  = pValue);
    }
  }

  void setIsPrimary(bool pValue)
  => (isPrimary != pValue)? setState(() => isPrimary = pValue): null;

  void listened(StreamEnvelope<LdModel> pEnvelope) {
    // Implementació futura
  }

  void onError(Object error, StackTrace stackTrace) {
    debugPrint("Error a LdButton: $error");
  }

  void onDone() {
    debugPrint("Stream tancat per LdButton");
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    
    // Colors per defecte basats en el tema
    final defaultPrimaryColor = primaryColor ?? theme.primaryColor;
    final defaultPrimaryTextColor = primaryTextColor ?? theme.primaryTextTheme.labelLarge?.color ?? Colors.white;
    final defaultSecondaryColor = secondaryColor ?? Colors.transparent;
    final defaultSecondaryTextColor = secondaryTextColor ?? theme.primaryColor;
    final defaultDisabledColor = disabledColor ?? theme.disabledColor.withAlpha(toAlpha(0.2));
    final defaultDisabledTextColor = disabledTextColor ?? theme.disabledColor;

    // Determinem colors basats en l'estat
    final Color backgroundColor = isEnabled
        ? (isPrimary ? defaultPrimaryColor : defaultSecondaryColor)
        : defaultDisabledColor;
    
    final Color textColor = isEnabled
        ? (isPrimary ? defaultPrimaryTextColor : defaultSecondaryTextColor)
        : defaultDisabledTextColor;
    
    // Determinem l'estil del text
    final TextStyle effectiveTextStyle = (textStyle ?? theme.textTheme.labelLarge ?? const TextStyle())
        .copyWith(color: textColor);

    // Construïm el contingut del botó
    Widget buttonContent = Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (leftIcon != null) ...[
          Icon(leftIcon, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            ((widget.wModel as LdButtonModel).text)?? "",
            style: effectiveTextStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    // Construïm el botó
    final buttonStyle = ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      disabledBackgroundColor: defaultDisabledColor,
      disabledForegroundColor: defaultDisabledTextColor,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        side: isPrimary ? BorderSide.none : BorderSide(color: defaultPrimaryColor),
      ),
      minimumSize: Size(width ?? 0, height ?? 48),
      maximumSize: expanded 
          ? const Size(double.infinity, double.infinity)
          : null,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
    );

    // Botó final
    Widget button = ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: buttonStyle,
      focusNode: FocusNode(canRequestFocus: false, skipTraversal: true),
      child: buttonContent,
    );

    // Apliquem el width si és necessari
    if (width != null) {
      button = SizedBox(width: width, child: button);
    }

    // Si és expanded, el fem ocupar tot l'espai disponible
    if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  @override
  String baseTag() => "LdButtonCtrl";

  @override
  Widget buildWidget(BuildContext pBCtx) {
    // TODO: implement buildWidget
    throw UnimplementedError();
  }

  @override
  void onDeactivate() {
    // TODO: implement onDeactivate
  }

  @override
  void onDependenciesResolved() {
    // TODO: implement onDependenciesResolved
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
  }

  @override
  void onInit() {
    // TODO: implement onInit
  }

  @override
  void onRendered(BuildContext pBCtx) {
    // TODO: implement onRendered
  }

  @override
  void onWidgetUpdated(covariant StatefulWidget pOldWidget) {
    // TODO: implement onWidgetUpdated
  }
}