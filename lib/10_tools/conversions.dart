// conversions.dart
// Diferents conversions que es fan servir repetidament al llarg del projecte.
// CreatedAt: 2025/04/18 dv. JIQ

import 'package:ld_wbench5/10_tools/null_mang.dart';

/// Calcula l'equivalent en byte de l'aplha en percentatge double ({0, .., 1}).
int toAlpha(double pValue) {
  if (pValue > 1.0) { pValue = 1.0; }
  if (pValue < 0.0) { pValue  = 0.0; }
  
  return (pValue  * 255.0).toInt();
} 

/// Divideix una cadena en dos parts segons un caràcter.
(String, String?) splitAt(String? pStr, String pChar) {
  if (isNull(pStr)) return (pStr?? "!?", null);
  List<String> strs = pStr!.split(pChar);
  return (strs.first, strs.last);
}