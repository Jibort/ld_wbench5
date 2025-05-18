// lib/ui/extensions/string_extensions.dart
// Extensions per facilitar la gestió de strings i formats 
// Created: 2025/05/06 dt. CLA 
// Updated: 2025/05/14 dc. CLA[JIQ] - Afegir suport per interpolació amb paràmetres posicionals, nomenats i variables automàtiques

// import 'package:ld_wbench5/core/L10n/string_tx.dart';
// import 'package:ld_wbench5/core/extensions/map_extensions.dart';
// import 'package:ld_wbench5/services/L.dart';

// /// Simplificació del codi per a llistes de cadenes de caràcters.
// typedef Strings = List<String>;

// /// Patró per a identificar inequívocament entre claus i paràmetrers d'interpolació.
// final RegExp _symbolPattern = RegExp(r'[\s\{\.\:\;\,\-]');

// /// Extensions per facilitar la gestió de strings i formats 
// extension StringExtensions on String {
//   String tx({ Strings? pPosArgs, Strings? pNamedArgs }) {
//     return L.tx(this, pPosArgs,);

//   }

//   /// Extreu la clau de traducció d'un string (només la part que comença amb ##)
//   String get extractKey {
//     if (!startsWith('##')) return this;
    
//     // Buscar el primer caràcter d'espai o símbol especial
//     final match = _symbolPattern.firstMatch(this);
    
//     return (match == null)
//       ? this
//       : substring(0, match.start);
//   }


//   /// Traducció simple sense paràmetres
//   String get tx_old => StringTx.tx(this);
  
//   /// Traducció amb paràmetres posicionals
//   /// Exemple: "user_count".txWith(["Joan", "5"])
//   /// Per cadena: "L'usuari {0} té {1} elements"
//   String txWith(List<String> positionalArgs) {
//     return StringTx.tx(this, positionalArgs, null);
//   }
  
//   /// Traducció amb paràmetres nomenats
//   /// Exemple: "welcome".txArgs(LdMap&lt;String&gt;()..addAll({"name": "Joan", "count": "5"}))
//   /// Per cadena: "Hola {name}, tens {count} missatges"
//   String txArgs(LdMap<String> namedArgs) {
//     return StringTx.tx(this, null, namedArgs);
//   }
  
//   /// Traducció amb ambdós tipus de paràmetres
//   /// Exemple: "complex".txFull(["Joan"], LdMap&lt;String&gt;()..["status"] = "nous")
//   /// Per cadena: "Hola {0}, tens missatges {status}"
//   String txFull(List<String> positionalArgs, LdMap<String> namedArgs) {
//     return StringTx.tx(this, positionalArgs, namedArgs);
//   }
  
//   /// Traducció només amb variables automàtiques (sense paràmetres explícits)
//   /// Útil per cadenes que només usen {current_date}, {user_name}, etc.
//   String get txAuto => StringTx.tx(this, null, null);
// }

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/services/L.dart';

typedef Strings = List<String>;

final RegExp _symbolPattern = RegExp(r'[\s\{\.\:\;\,\-]');

final RegExp _regex = RegExp(r'##\w+');

/// Extensions útils per a strings
extension StringExtensions on String {
  // TRADUCCIÓ AMB INTERPOLACIÓ ===========================
  /// Tradueix les claus dins la cadena i hi aplica interpolació
  /// Tradueix les claus dins la cadena i hi aplica interpolació
  String tx([
    Strings? posArgs = const [],
    MapStrings? namedArgs = const {} ]) 
  { 
    String result = this;

    // Detectar claus de traducció dins el text (ex: ##CLAU)
    final matches = _regex.allMatches(result).toList();

    if (matches.isNotEmpty) {
      // Si hi ha claus de traducció, traduir-les
      for (final match in matches) {
        final key = match.group(0);
        if (key != null) {
          // Traduir només aquesta clau específica
          final translated = L.tx(key, posArgs, namedArgs);
          // Substituir només aquesta clau específica
          result = result.replaceAll(key, translated);
        }
      }
    }
    
    // Si no hi ha claus de traducció o després de substituir totes les claus,
    // apliquem els arguments a tot el resultat per qualsevol interpolació
    result = StringTx.applyInterpolation(result, posArgs, namedArgs);

    return result;
  }

  // FORMAT POSICIONAL PUR ================================
  /// Aplica format reemplaçant {0}, {1}, etc. amb els arguments proporcionats
  String format(Strings args) {
    String result = this;
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("Format: text original = '$result', args = $args");
    for (int i = 0; i < args.length; i++) {
      String placeholder = '{$i}';
      String replacement = args[i];
      result = result.replaceAll(placeholder, replacement);
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("Format: reemplaçant '$placeholder' per '$replacement', resultat = '$result'");
    }
    return result;
  }

  // EXTREURE CLAU D'UN STRING ============================
  /// Extreu la clau de traducció d'un string (només la part que comença amb ##)
  String get extractKey {
    if (!contains('##')) return this;
    final match = _symbolPattern.firstMatch(this);
    return (match == null) ? this : substring(0, match.start);
  }
}
