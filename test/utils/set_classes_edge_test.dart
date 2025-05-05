// test/utils/set_classes_edge_test.dart
// Proves específiques dels casos límit de les classes FullSet, OnceSet, StrFullSet i StrOnceSet
// Created: 2025/05/05 dl.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/utils/full_set.dart';
import 'package:ld_wbench5/utils/once_set.dart';
import 'package:ld_wbench5/utils/str_full_set.dart';
import 'package:ld_wbench5/utils/str_once_set.dart';
import 'package:ld_wbench5/services/L.dart';

// Matcher personalitzat per verificar excepcions de Debug.fatal
final throwsDebugFatalError = throwsA(predicate((e) => 
  e.toString().contains('FATAL') || e is AssertionError));

void main() {
  // Necessari per inicialitzar L abans de usar-lo en les proves
  setUp(() {
    L.deviceLocale = const Locale('ca'); // Inicialitza amb un valor de prova
  });

  group('Casos límit amb constructors', () {
    test('FullSet - Ara accepta StringTx nuls amb isNullable = false', () {
      // StringTx amb valor null
      final stringTxNul = StringTx(null);
      
      // Ara es pot crear amb StringTx que té valor null encara que isNullable = false
      final fullSet1 = FullSet<StringTx>(pInst: stringTxNul, pIsNullable: false);
      expect(fullSet1.isSet, isFalse); // No s'hauria de considerar com a establert
      expect(fullSet1.isNullable, isFalse); // No és nul·lable
      
      // Però no es pot assignar null després
      expect(() => fullSet1.set(null), throwsAssertionError);
      
      // També es pot crear amb valor null explícit encara que isNullable = false
      final fullSet2 = FullSet<StringTx>(pInst: null, pIsNullable: false);
      expect(fullSet2.isSet, isFalse);
      expect(fullSet2.isNullable, isFalse);
      expect(fullSet2.isNull, isTrue);
    });
    
    test('OnceSet - Ara accepta StringTx nuls amb isNullable = false', () {
      // StringTx amb valor null
      final stringTxNul = StringTx(null);
      
      // Ara es pot crear amb StringTx que té valor null encara que isNullable = false
      final onceSet1 = OnceSet<StringTx>(pInst: stringTxNul, pIsNullable: false);
      expect(onceSet1.isSet, isFalse); // No s'hauria de considerar com a establert
      expect(onceSet1.isNullable, isFalse); // No és nul·lable
      
      // Però no es pot assignar null després
      expect(() => onceSet1.set(null), throwsAssertionError);
      
      // També es pot crear amb valor null explícit encara que isNullable = false
      final onceSet2 = OnceSet<StringTx>(pInst: null, pIsNullable: false);
      expect(onceSet2.isSet, isFalse);
      expect(onceSet2.isNullable, isFalse);
      expect(onceSet2.isNull, isTrue);
    });
    
    test('StrFullSet - Ara accepta valors nuls en constructor amb isNullable = false', () {
      // StrFullSet ara accepta null al constructor encara que isNullable = false
      final strFullSet1 = StrFullSet(pStrOrKey: null, pIsNullable: false);
      expect(strFullSet1.isSet, isFalse);
      expect(strFullSet1.isNullable, isFalse);
      expect(strFullSet1.isNull, isTrue);
      
      // Però no accepta null al setter si isNullable = false
      expect(() => strFullSet1.t = null, throwsDebugFatalError);
      
      // I no accepta assignar StringTx nul si isNullable = false
      final strFullSet2 = StrFullSet(pStrOrKey: 'inicial', pIsNullable: false);
      expect(() => strFullSet2.set(StringTx(null)), throwsAssertionError);
    });
    
    test('StrOnceSet - Ara accepta valors nuls en constructor amb isNullable = false', () {
      // StrOnceSet ara accepta null al constructor encara que isNullable = false
      final strOnceSet1 = StrOnceSet(pStrOrKey: null, pIsNullable: false);
      expect(strOnceSet1.isSet, isFalse);
      expect(strOnceSet1.isNullable, isFalse);
      expect(strOnceSet1.isNull, isTrue);
      
      // Però no accepta null al set() si isNullable = false
      expect(() => strOnceSet1.set(null), throwsAssertionError);
      expect(() => strOnceSet1.set(StringTx(null)), throwsAssertionError);
      
      // Però sí que permet assignar un valor no null
      strOnceSet1.set(StringTx('valor'));
      expect(strOnceSet1.t, equals('valor'));
      
      // I un cop assignat, no accepta canviar el contingut
      expect(() => strOnceSet1.t = 'nou valor', throwsDebugFatalError);
    });
  });
  
  group('Comportament amb assercions en getters', () {
    test('FullSet - get() amb instància no establerta', () {
      // Creació de FullSet buit
      final fullSet = FullSet<String>();
      expect(fullSet.isSet, isFalse);
      
      // get() sense error personalitzat
      expect(() => fullSet.get(), throwsAssertionError);
      
      // get() amb error personalitzat
      expect(() => fullSet.get(pError: 'Error personalitzat'), throwsAssertionError);
      
      // Si assignem un valor, get() ja no llança error
      fullSet.set('valor');
      expect(fullSet.get(), equals('valor'));
    });
    
    test('OnceSet - get() amb instància no establerta', () {
      // Creació de OnceSet buit
      final onceSet = OnceSet<String>();
      expect(onceSet.isSet, isFalse);
      
      // get() sense error personalitzat
      expect(() => onceSet.get(), throwsAssertionError);
      
      // get() amb error personalitzat
      expect(() => onceSet.get(pError: 'Error personalitzat'), throwsAssertionError);
      
      // Si assignem un valor, get() ja no llança error
      onceSet.set('valor');
      expect(onceSet.get(), equals('valor'));
    });
    
    test('StrFullSet - accés a propietat t amb instància no establerta', () {
      // Creació de StrFullSet buit
      final strFullSet = StrFullSet();
      expect(strFullSet.isSet, isFalse);
      
      // Accés a t (hauria de ser nul, no hauria de llançar excepció)
      expect(strFullSet.t, isNull);
      
      // get() sí que llançarà excepció
      expect(() => strFullSet.get(), throwsAssertionError);
      
      // Si assignem un valor, get() ja no llança error
      strFullSet.t = 'valor';
      expect(strFullSet.get(), isNotNull);
    });
    
    test('StrOnceSet - accés a propietat t amb instància no establerta', () {
      // Creació de StrOnceSet buit
      final strOnceSet = StrOnceSet();
      expect(strOnceSet.isSet, isFalse);
      
      // Accés a t (hauria de ser nul, no hauria de llançar excepció)
      expect(strOnceSet.t, isNull);
      
      // get() sí que llançarà excepció
      expect(() => strOnceSet.get(), throwsAssertionError);
      
      // Si assignem un valor, get() ja no llança error
      strOnceSet.t = 'valor';
      expect(strOnceSet.get(), isNotNull);
    });
  });
  
  group('Cicle de vida i interaccions entre isNullable i isNull', () {
    test('FullSet - Canvis d\'estat complets', () {
      // Creació de FullSet amb isNullable = true i sense valor inicial
      final fullSet = FullSet<String>(pIsNullable: true);
      expect(fullSet.isSet, isFalse);
      expect(fullSet.isNull, isTrue);
      
      // Canvi a un valor no nul
      fullSet.set('valor');
      expect(fullSet.isSet, isTrue);
      expect(fullSet.isNull, isFalse);
      expect(fullSet.get(), equals('valor'));
      
      // Canvi a null (permès si isNullable)
      fullSet.set(null);
      expect(fullSet.isSet, isTrue); // Segueix considerat "establert"
      expect(fullSet.isNull, isTrue);
      
      // Canvi a un altre valor
      fullSet.set('altre valor');
      expect(fullSet.isSet, isTrue);
      expect(fullSet.isNull, isFalse);
      expect(fullSet.get(), equals('altre valor'));
    });
    
    test('OnceSet - Cicle de vida amb isNullable = false', () {
      // Creació de OnceSet amb isNullable = false sense valor inicial
      final onceSet = OnceSet<String>(pIsNullable: false);
      expect(onceSet.isSet, isFalse);
      expect(onceSet.isNullable, isFalse);
      expect(onceSet.isNull, isTrue);
      
      // No podem assignar null
      expect(() => onceSet.set(null), throwsAssertionError);
      
      // Assignem un valor no nul
      onceSet.set('valor');
      expect(onceSet.isSet, isTrue);
      expect(onceSet.isNull, isFalse);
      expect(onceSet.get(), equals('valor'));
      
      // No podem canviar-lo a res (ni a null ni a no null)
      expect(() => onceSet.set('nou'), throwsAssertionError);
      expect(() => onceSet.set(null), throwsAssertionError);
    });
    
    test('StrFullSet - Cicle de vida complet amb StringTx', () {
      // StringTx nul i no nul
      final stringTxNul = StringTx(null);
      final stringTxValor = StringTx('valor');
      
      // StrFullSet amb StringTx nul
      final strFullSet = StrFullSet();
      expect(strFullSet.isSet, isFalse);
      expect(strFullSet.isNull, isTrue);
      
      // Assignem un StringTx no nul
      strFullSet.set(stringTxValor);
      expect(strFullSet.isSet, isTrue);
      expect(strFullSet.isNull, isFalse);
      expect(strFullSet.t, equals('valor'));
      
      // Canviem el contingut amb .t
      strFullSet.t = 'nou valor';
      expect(strFullSet.t, equals('nou valor'));
      
      // Canviem a una clau de traducció
      strFullSet.t = '##sWelcome';
      expect(strFullSet.isNull, isFalse);
      
      // El text que obtenim depèn de l'idioma actual
      final currentLocale = L.getCurrentLocale().languageCode;
      if (currentLocale == 'ca') {
        expect(strFullSet.t, equals('Benvingut/da'));
      }
      
      // Canviem a null (si isNullable)
      strFullSet.t = null;
      expect(strFullSet.isNull, isTrue);
    });
    
    test('StrOnceSet - Interacció especial amb contingut vs. referència', () {
      // Creació de StrOnceSet sense valor inicial
      final strOnceSet = StrOnceSet();
      expect(strOnceSet.isSet, isFalse);
      
      // Primer set amb StringTx
      strOnceSet.set(StringTx('valor'));
      expect(strOnceSet.isSet, isTrue);
      expect(strOnceSet.t, equals('valor'));
      
      // No es pot canviar la referència
      expect(() => strOnceSet.set(StringTx('nou')), throwsAssertionError);
      
      // Tampoc es pot canviar el contingut amb .t després de set()
      expect(() => strOnceSet.t = 'modificat', throwsDebugFatalError);
      
      // El valor original es manté
      expect(strOnceSet.t, equals('valor'));
      
      // Alternativa: Creem StrOnceSet sense valor inicial i assignem amb .t
      final strOnceSetT = StrOnceSet();
      strOnceSetT.t = 'valor amb t';
      expect(strOnceSetT.t, equals('valor amb t'));
      
      // Un cop assignat, no es pot canviar amb .t
      expect(() => strOnceSetT.t = 'nou valor amb t', throwsDebugFatalError);
      
      // Comprovació final amb isNullable = false
      final strOnceSetNoNul = StrOnceSet(pIsNullable: false);
      strOnceSetNoNul.set(StringTx('valor fix'));
      
      // No podem canviar el text
      expect(() => strOnceSetNoNul.t = 'altre valor fix', throwsDebugFatalError);
      
      // Tampoc a null
      expect(() => strOnceSetNoNul.t = null, throwsDebugFatalError);
    });
  });
  
  group('Proves específiques amb claus de localització', () {
    test('Verificar detecció correcta de claus de traducció', () {
      // Creació de StringTx amb clau
      final stringTxClau = StringTx('##sWelcome');
      expect(stringTxClau.isTranslatable, isTrue);
      expect(stringTxClau.key, equals('##sWelcome'));
      expect(stringTxClau.literalText, isNull);
      
      // Creació de StringTx amb text literal
      final stringTxLiteral = StringTx('Hola');
      expect(stringTxLiteral.isTranslatable, isFalse);
      expect(stringTxLiteral.key, isNull);
      expect(stringTxLiteral.literalText, equals('Hola'));
      
      // Canvi de literal a clau
      stringTxLiteral.set('##sWelcome');
      expect(stringTxLiteral.isTranslatable, isTrue);
      expect(stringTxLiteral.key, equals('##sWelcome'));
      
      // Canvi de clau a literal
      stringTxClau.set('Adéu');
      expect(stringTxClau.isTranslatable, isFalse);
      expect(stringTxClau.literalText, equals('Adéu'));
    });
    
    test('StringTx amb claus inexistents', () {
      // Creació de StringTx amb clau inexistent
      final stringTxInexistent = StringTx('##clauInexistent');
      expect(stringTxInexistent.isTranslatable, isTrue);
      
      // El text hauria de ser errInText del fitxer ui_consts.dart
      // Però com no tenim accés a aquest valor en les proves, només comprovem
      // que no sigui null
      expect(stringTxInexistent.text, isNotNull);
    });
    
    test('StrFullSet amb canvi d\'idioma múltiple', () {
      // Guardem l'idioma original
      final idiomaOriginal = L.getCurrentLocale();
      
      // Establim català
      L.setCurrentLocale(const Locale('ca'));
      
      // Creem StrFullSet amb clau
      final strFullSet = StrFullSet(pStrOrKey: '##sToggleThemeButtonVisibility');
      expect(strFullSet.t, equals('Alternar visibilitat botó tema'));
      
      // Canviem a espanyol
      L.setCurrentLocale(const Locale('es'));
      expect(strFullSet.t, equals('Alternar visibilidad botón tema'));
      
      // Canviem a anglès
      L.setCurrentLocale(const Locale('en'));
      expect(strFullSet.t, equals('Toggle theme button visibility'));
      
      // Canviem a idioma inexistent (hauria de caure a espanyol per defecte)
      L.setCurrentLocale(const Locale('de'));
      // Aquest test és específic de la implementació i podria fallar
      // si l'idioma per defecte no és 'es'
      expect(L.getCurrentLocale().languageCode, equals('es'));
      
      // Restaurem l'idioma original
      L.setCurrentLocale(idiomaOriginal);
    });
    
    test('Canvi d\'idioma per OnceSet inicialitzat indirectament', () {
      // Guardem l'idioma original
      final idiomaOriginal = L.getCurrentLocale();
      
      // Establim català
      L.setCurrentLocale(const Locale('ca'));
      
      // Creem una instància buida però amb clau de traducció
      final strOnceSet = StrOnceSet(pIsNullable: false);
      expect(strOnceSet.isSet, isFalse);
      
      // Assignem un StringTx amb clau
      strOnceSet.set(StringTx('##sChangeLanguage'));
      expect(strOnceSet.t, equals('Canvia l\'Idioma'));
      
      // Canviem l'idioma i verificar canvi de text
      L.setCurrentLocale(const Locale('es'));
      expect(strOnceSet.t, equals('Cambiar Idioma'));
      
      // Un altre canvi d'idioma
      L.setCurrentLocale(const Locale('en'));
      expect(strOnceSet.t, equals('Change Language'));
      
      // Restaurem l'idioma original
      L.setCurrentLocale(idiomaOriginal);
    });
  });
}
