import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

TextScaler _txtScaler = MediaQuery.of(Get.context!).textScaler;

TextStyle txsAppBarTitleStyle({Color? pFgColor}) {
  ThemeData thData = Theme.of(Get.context!);

  return thData.appBarTheme.titleTextStyle!.copyWith(
    color: pFgColor ?? Colors.white,
    fontSize: _txtScaler.scale(15.0.sp),
  );
}

TextStyle txsAppBarSubtitleStyle({Color? pFgColor}) {
  ThemeData thData = Theme.of(Get.context!);

  return thData.appBarTheme.titleTextStyle!.copyWith(
    color: pFgColor ?? Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: _txtScaler.scale(9.0.sp),
  );
}

// Estil per a les etiquetes de camps d'edició
TextStyle txsInputLabelStyle({Color? pFgColor}) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: _txtScaler.scale(10.0.sp), // Igual que els botons
    fontStyle: FontStyle.normal,
    color: pFgColor,
    fontFamily: 'Montserrat',
  );
}

TextStyle txsInputFloatingStyle({Color? pFgColor}) {
  ThemeData thData = Theme.of(Get.context!);

  return thData.inputDecorationTheme.floatingLabelStyle!.copyWith(
    color: pFgColor,
    fontWeight: FontWeight.normal,
    fontFamily: 'Montserrat',
  );
  //   fontWeight: FontWeight.w500,
  //   fontSize: _txtScaler.scale(10.0.sp), // Igual que els botons
  //   fontStyle: FontStyle.normal,
  //   color: pFgColor,
  //   // fontFamily: 'Roboto',
  // );
}

// Estil per al text d'entrada en camps d'edició
TextStyle txsInputTextStyle({Color? pFgColor}) {
  return TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: _txtScaler.scale(10.0.sp), // Igual que els botons
    fontStyle: FontStyle.normal,
    color: pFgColor,
    fontFamily: 'Montserrat',
  );
}

// Estil per al text d'ajuda en camps d'edició
TextStyle? _inputHelperStyle;
TextStyle txsInputHelperStyle({Color? pFgColor}) {
  _inputHelperStyle ??= TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: _txtScaler.scale(8.0.sp),
    fontStyle: FontStyle.normal,
    color: pFgColor ?? Colors.grey.shade600,
    fontFamily: 'Montserrat',
  );

  return _inputHelperStyle!;
}

// Estil per al text d'error en camps d'edició
TextStyle txsInputErrorStyle({Color? pFgColor}) {
  return TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: _txtScaler.scale(12.0.sp),
    fontStyle: FontStyle.normal,
    color: pFgColor ?? Colors.red,
    fontFamily: 'Montserrat',
  );
}
