// test/utils/set_classes_test.dart
// Proves de les classes FullSet, OnceSet, StrFullSet i StrOnceSet
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

// Classes de prova declarades fora de mètodes de test
class TestConfig {
  final OnceSet<Map<String, dynamic>> settings = OnceSet();
  
  void initialize(Map<String, dynamic> initialSettings) {
    settings.set(initialSettings);
  }
  
  dynamic getSetting(String key) {
    return settings.get()![key];
  }
}

class TestUIComponent {
  final StrFullSet label;
  final StrOnceSet title;
  
  TestUIComponent({required String labelKey, required String titleKey})
    : label = StrFullSet(pStrOrKey: labelKey),
      title = StrOnceSet(pStrOrKey: titleKey);
      
  void updateLabel(String newLabelKey) {
    label.t = newLabelKey;
  }
  
  Map<String, String?> getTexts() {
    return {
      'label': label.t,
      'title': title.t
    };
  }
}

class TestForm {
  final Map<String, StrOnceSet> labels = {};
  final Map<String, StrFullSet> values = {};
  
  void addField(String fieldName, String labelKey, {String? initialValue}) {
    labels[fieldName] = StrOnceSet(pStrOrKey: labelKey);
    values[fieldName] = StrFullSet(pStrOrKey: initialValue);
  }
  
  String? getLabelText(String fieldName) {
    return labels[fieldName]?.t;
  }
  
  void setValue(String fieldName, String? value) {
    values[fieldName]?.t = value;
  }
  
  String? getValue(String fieldName) {
    return values[fieldName]?.t;
  }
}

void main() {
  // Necessari per inicialitzar L abans de usar-lo en les proves
  setUp(() {
    L.deviceLocale = const Locale('ca'); // Inicialitza amb un valor de prova
  });

  group('FullSet Tests', () {
    test('Creació amb valor inicial', () {
      final fullSet = FullSet<String>(pInst: 'test');
      expect(fullSet.isSet, isTrue);
      expect(fullSet.isNullable, isTrue);
      expect(fullSet.isNull, isFalse);
      expect(fullSet.get(), equals('test'));
    });

    test('Creació amb valor null i nullable = true', () {
      final fullSet = FullSet<String>(pInst: null, pIsNullable: true);
      expect(fullSet.isSet, isFalse);
      expect(fullSet.isNullable, isTrue);
      expect(fullSet.isNull, isTrue);
    });
    
    test('Creació amb valor null i nullable = false (comportament revisat)', () {
      // Ara el constructor SÍ accepta null encara que pIsNullable = false
      final fullSet = FullSet<String>(pInst: null, pIsNullable: false);
      expect(fullSet.isSet, isFalse);
      expect(fullSet.isNullable, isFalse);
      expect(fullSet.isNull, isTrue);
    });

    test('Set i get múltiples vegades', () {
      final fullSet = FullSet<int>();
      
      // Inicialment no està definit
      expect(fullSet.isSet, isFalse);
      
      // Assignem primer valor
      fullSet.set(42);
      expect(fullSet.isSet, isTrue);
      expect(fullSet.get(), equals(42));
      
      // Canviem el valor
      fullSet.set(100);
      expect(fullSet.get(), equals(100));
      
      // Podem assignar null si isNullable = true
      fullSet.set(null);
      expect(fullSet.isNull, isTrue);
    });

    test('No acceptar null en set() si isNullable = false', () {
      // La instància no hauria d'acceptar set(null) si isNullable = false
      final fullSet = FullSet<int>(pInst: 10, pIsNullable: false);
      expect(() => fullSet.set(null), throwsAssertionError);
    });
    
    test('Error al obtenir valor no definit', () {
      final fullSet = FullSet<String>();
      
      expect(() => fullSet.get(), throwsAssertionError);
      expect(() => fullSet.get(pError: 'Error personalitzat'), throwsAssertionError);
    });
  });

  group('OnceSet Tests', () {
    test('Creació amb valor inicial', () {
      final onceSet = OnceSet<String>(pInst: 'test');
      expect(onceSet.isSet, isTrue);
      expect(onceSet.isNullable, isTrue);
      expect(onceSet.isNull, isFalse);
      expect(onceSet.get(), equals('test'));
    });

    test('Creació amb valor null i nullable = true', () {
      final onceSet = OnceSet<String>(pInst: null, pIsNullable: true);
      expect(onceSet.isSet, isFalse);
      expect(onceSet.isNullable, isTrue);
      expect(onceSet.isNull, isTrue);
    });
    
    test('Creació amb valor null i nullable = false (comportament revisat)', () {
      // Ara el constructor SÍ accepta null encara que pIsNullable = false
      final onceSet = OnceSet<String>(pInst: null, pIsNullable: false);
      expect(onceSet.isSet, isFalse);
      expect(onceSet.isNullable, isFalse);
      expect(onceSet.isNull, isTrue);
    });

    test('Set només una vegada', () {
      final onceSet = OnceSet<int>();
      
      // Inicialment no està definit
      expect(onceSet.isSet, isFalse);
      
      // Assignem valor
      onceSet.set(42);
      expect(onceSet.isSet, isTrue);
      expect(onceSet.get(), equals(42));
      
      // No podem canviar el valor
      expect(() => onceSet.set(100), throwsAssertionError);
      expect(onceSet.get(), equals(42)); // El valor no ha canviat
    });

    test('No acceptar null en set() si isNullable = false', () {
      // La instància ja creada no hauria d'acceptar set(null) si isNullable = false
      final onceSet = OnceSet<int>(pIsNullable: false);
      
      expect(() => onceSet.set(null), throwsAssertionError);
    });
    
    test('Error al obtenir valor no definit', () {
      final onceSet = OnceSet<String>();
      
      expect(() => onceSet.get(), throwsAssertionError);
      expect(() => onceSet.get(pError: 'Error personalitzat'), throwsAssertionError);
    });
    
    test('Missatge d\'error personalitzat', () {
      final onceSet = OnceSet<int>(pInst: 5);
      
      expect(() => onceSet.set(10, pError: 'Error personalitzat'), throwsAssertionError);
    });
  });

  group('StrFullSet Tests amb textos literals', () {
    test('Creació amb valor inicial literal', () {
      final strFullSet = StrFullSet(pStrOrKey: 'test');
      expect(strFullSet.isSet, isTrue);
      expect(strFullSet.isNull, isFalse);
      expect(strFullSet.t, equals('test'));
    });
    
    test('Creació amb valor null acceptable si pIsNullable = true', () {
      final strFullSet = StrFullSet(pStrOrKey: null);
      expect(strFullSet.isSet, isFalse);
      expect(strFullSet.isNull, isTrue);
      expect(strFullSet.t, isNull);
    });
    
    test('Creació amb valor null i pIsNullable = false (comportament revisat)', () {
      // Ara el constructor SÍ hauria d'acceptar null encara que pIsNullable = false
      final strFullSet = StrFullSet(pStrOrKey: null, pIsNullable: false);
      expect(strFullSet.isSet, isFalse);
      expect(strFullSet.isNullable, isFalse);
      expect(strFullSet.isNull, isTrue);
      
      // Però no podem assignar null més tard
      expect(() => strFullSet.t = null, throwsAssertionError);
    });
    
    test('Modificar text literal directament', () {
      final strFullSet = StrFullSet(pStrOrKey: 'inicial');
      
      // Canviar el text
      strFullSet.t = 'modificat';
      expect(strFullSet.t, equals('modificat'));
      
      // Canviar-lo de nou
      strFullSet.t = 'altre valor';
      expect(strFullSet.t, equals('altre valor'));
      
      // Canviar a null si isNullable
      strFullSet.t = null;
      expect(strFullSet.isNull, isTrue);
    });
    
    test('No acceptar assignació de null si isNullable = false', () {
      final strFullSet = StrFullSet(pStrOrKey: 'valor', pIsNullable: false);
      
      // Utilitzem el matcher personalitzat per Exception llançada per Debug.fatal
      expect(() => strFullSet.t = null, throwsDebugFatalError);
      expect(() => strFullSet.set(null), throwsAssertionError);
      expect(() => strFullSet.set(StringTx(null)), throwsAssertionError);
    });
    
    test('Comportament amb StringTx que té isNull=true', () {
      final stringTx = StringTx(null);
      final strFullSet = FullSet<StringTx>(pInst: stringTx);
      
      // Encara que inst no és null, el StringTx té contingut null
      expect(strFullSet.isNull, isFalse); // Només comprova si _inst == null
      
      // A StrFullSet això està arreglat
      final strFullSetProper = StrFullSet();
      strFullSetProper.set(stringTx);
      
      expect(strFullSetProper.isNull, isTrue); // Aquesta detecta StringTx.isNull
    });
  });
  
  group('StrFullSet Tests amb claus de localització', () {
    test('Creació amb clau de localització', () {
      final strFullSet = StrFullSet(pStrOrKey: '##sWelcome');
      expect(strFullSet.isSet, isTrue);
      expect(strFullSet.isNull, isFalse);
      
      // Verificar que s'obté la traducció correcta segons l'idioma
      // Cal tenir en compte que això depèn de l'idioma actual configurat a L
      final currentLocale = L.getCurrentLocale().languageCode;
      String expectedText;
      
      if (currentLocale == 'ca') {
        expectedText = 'Benvingut/da';
      } else if (currentLocale == 'es') {
        expectedText = 'Bienvenido/a';
      } else {
        expectedText = 'Welcome';
      }
      
      expect(strFullSet.t, equals(expectedText));
    });
    
    test('Canvi d\'idioma afecta al text traduït', () {
      // Guardem l'idioma original per restaurar-lo després
      final originalLocale = L.getCurrentLocale();
      
      // Establim un idioma conegut
      L.setCurrentLocale(const Locale('ca'));
      
      final strFullSet = StrFullSet(pStrOrKey: '##sChangeLanguage');
      expect(strFullSet.t, equals('Canvia l\'Idioma'));
      
      // Canviem l'idioma
      L.setCurrentLocale(const Locale('es'));
      expect(strFullSet.t, equals('Cambiar Idioma'));
      
      // I un altre cop
      L.setCurrentLocale(const Locale('en'));
      expect(strFullSet.t, equals('Change Language'));
      
      // Restaurem l'idioma original
      L.setCurrentLocale(originalLocale);
    });
    
    test('Canvi de text literal a clau i viceversa', () {
      final strFullSet = StrFullSet(pStrOrKey: 'text inicial');
      expect(strFullSet.t, equals('text inicial'));
      
      // Canviem a una clau de traducció
      strFullSet.t = '##sWelcome';
      
      // Ara hauria de ser un text traduït
      final currentLocale = L.getCurrentLocale().languageCode;
      if (currentLocale == 'ca') {
        expect(strFullSet.t, equals('Benvingut/da'));
      } else if (currentLocale == 'es') {
        expect(strFullSet.t, equals('Bienvenido/a'));
      } else {
        expect(strFullSet.t, equals('Welcome'));
      }
      
      // Tornem a text literal
      strFullSet.t = 'nou text literal';
      expect(strFullSet.t, equals('nou text literal'));
    });
  });

  group('StrOnceSet Tests', () {
    test('Creació amb valor inicial literal', () {
      final strOnceSet = StrOnceSet(pStrOrKey: 'test');
      expect(strOnceSet.isSet, isTrue);
      expect(strOnceSet.isNull, isFalse);
      expect(strOnceSet.t, equals('test'));
    });
    
    test('Creació amb valor null acceptable si pIsNullable = true', () {
      final strOnceSet = StrOnceSet(pStrOrKey: null);
      expect(strOnceSet.isSet, isFalse);
      expect(strOnceSet.isNull, isTrue);
      expect(strOnceSet.t, isNull);
    });
    
    test('Creació amb valor null i pIsNullable = false (comportament revisat)', () {
      // Ara el constructor SÍ hauria d'acceptar null encara que pIsNullable = false
      final strOnceSet = StrOnceSet(pStrOrKey: null, pIsNullable: false);
      expect(strOnceSet.isSet, isFalse);
      expect(strOnceSet.isNullable, isFalse);
      expect(strOnceSet.isNull, isTrue);
      
      // Podem assignar un valor no nul després
      strOnceSet.set(StringTx('valor'));
      expect(strOnceSet.t, equals('valor'));
      
      // Però no podem assignar-hi null
      expect(() => strOnceSet.t = null, throwsDebugFatalError);
    });
    
    test('Set només una vegada amb StringTx', () {
      final strOnceSet = StrOnceSet();
      
      // Primera assignació
      strOnceSet.set(StringTx('valor'));
      expect(strOnceSet.t, equals('valor'));
      
      // No es pot canviar
      expect(() => strOnceSet.set(StringTx('nou')), throwsAssertionError);
    });
    
    test('No acceptar assignació de null si isNullable = false', () {
      final strOnceSet = StrOnceSet(pIsNullable: false);
      
      // No podem assignar null
      expect(() => strOnceSet.set(null), throwsAssertionError);
      expect(() => strOnceSet.set(StringTx(null)), throwsAssertionError);
      
      // Però sí un valor no nul
      strOnceSet.set(StringTx('valor'));
      expect(strOnceSet.t, equals('valor'));
      
      // I no podem canviar a null després
      expect(() => strOnceSet.t = null, throwsDebugFatalError);
    });
    
    test('Modificar text directament - comportament especial', () {
      final strOnceSet = StrOnceSet();
      
      // Primera modificació
      strOnceSet.t = 'valor';
      expect(strOnceSet.t, equals('valor'));
      
      // La segona modificació amb t llança error si la instància ja està establerta
      expect(() => strOnceSet.t = 'nou valor', throwsDebugFatalError);
      
      // El valor no ha canviat
      expect(strOnceSet.t, equals('valor'));
      
      // I tampoc no podem usar el mètode set() de nou
      expect(() => strOnceSet.set(StringTx('error')), throwsAssertionError);
    });
    
    test('No acceptar assignacions múltiples de la instància ni del contingut', () {
      // Creem amb text inicial
      final strOnceSet = StrOnceSet(pStrOrKey: 'inicial');
      expect(strOnceSet.t, equals('inicial'));
      
      // No podem canviar la referència
      expect(() => strOnceSet.set(StringTx('nou')), throwsAssertionError);
      
      // Tampoc podem canviar el contingut intern
      expect(() => strOnceSet.t = 'modificat', throwsDebugFatalError);
      
      // El contingut no ha canviat
      expect(strOnceSet.t, equals('inicial'));
    });
    
    test('Clau de localització en StrOnceSet', () {
      // Guardem l'idioma original per restaurar-lo després
      final originalLocale = L.getCurrentLocale();
      
      // Establim un idioma conegut
      L.setCurrentLocale(const Locale('ca'));
      
      final strOnceSet = StrOnceSet(pStrOrKey: '##sChangeTheme');
      expect(strOnceSet.t, equals('Canvia el Tema'));
      
      // Canviem l'idioma
      L.setCurrentLocale(const Locale('en'));
      expect(strOnceSet.t, equals('Change Theme'));
      
      // Restaurem l'idioma original
      L.setCurrentLocale(originalLocale);
    });
  });

  group('Casos d\'ús complexos', () {
    test('FullSet amb tipus complexos', () {
      // Usant un mapa com a tipus complex
      final fullSet = FullSet<Map<String, dynamic>>(
        pInst: {'id': 1, 'name': 'Test'}
      );
      
      expect(fullSet.get()!['name'], equals('Test'));
      
      // Modificar el mapa directament (això no canvia la referència)
      fullSet.get()!['name'] = 'Modified';
      expect(fullSet.get()!['name'], equals('Modified'));
      
      // Assignar un mapa completament nou
      fullSet.set({'id': 2, 'name': 'New'});
      expect(fullSet.get()!['id'], equals(2));
    });
    
    test('OnceSet com a propietat de classe', () {
      final config = TestConfig();
      config.initialize({'debug': true, 'apiUrl': 'https://api.example.com'});
      
      expect(config.getSetting('debug'), isTrue);
      expect(config.getSetting('apiUrl'), equals('https://api.example.com'));
      
      // No es pot inicialitzar de nou
      expect(() => config.initialize({'debug': false}), throwsAssertionError);
    });
    
    test('Comparació de comportament en cascada', () {
      // FullSet permet múltiples canvis
      final fullString = FullSet<String>(pInst: 'A');
      fullString.set('B');
      fullString.set('C');
      expect(fullString.get(), equals('C'));
      
      // OnceSet només un canvi
      final onceString = OnceSet<String>(pInst: 'A');
      expect(() => onceString.set('B'), throwsAssertionError);
      expect(onceString.get(), equals('A'));
      
      // StrFullSet permet múltiples canvis
      final strFull = StrFullSet(pStrOrKey: 'A');
      strFull.t = 'B';
      strFull.t = 'C';
      expect(strFull.t, equals('C'));
      
      // StrOnceSet NO permet canviar el contingut intern del StringTx,
      // NI la instància en si
      final strOnce = StrOnceSet(pStrOrKey: 'A');
      // Això NO funciona perquè StrOnceSet no permet modificar després d'inicialitzar
      expect(() => strOnce.t = 'B', throwsDebugFatalError);
      expect(strOnce.t, equals('A'));  // El valor no canvia
      
      // I tampoc permet assignar una nova instància
      expect(() => strOnce.set(StringTx('C')), throwsAssertionError);
    });
  });
  
  group('Tests amb casos d\'ús reals', () {
    test('Classe que utilitza StrFullSet per a etiquetes d\'UI', () {
      // Guardem l'idioma original per restaurar-lo després
      final originalLocale = L.getCurrentLocale();
      
      // Establim un idioma conegut per a la prova
      L.setCurrentLocale(const Locale('ca'));
      
      // Creem un component amb textos localitzables
      final component = TestUIComponent(
        labelKey: '##sChangeLanguage',
        titleKey: '##sAppSabina'
      );
      
      // Verificar texts en català
      expect(component.getTexts()['label'], equals('Canvia l\'Idioma'));
      expect(component.getTexts()['title'], equals('Aplicació Sabina'));
      
      // Canviar l'idioma
      L.setCurrentLocale(const Locale('es'));
      
      // Verificar textos en espanyol
      expect(component.getTexts()['label'], equals('Cambiar Idioma'));
      expect(component.getTexts()['title'], equals('Aplicación Sabina'));
      
      // Canviar l'etiqueta a un altre text
      component.updateLabel('##sChangeTheme');
      expect(component.getTexts()['label'], equals('Cambiar Tema'));
      
      // També podem canviar a text literal
      component.updateLabel('Etiqueta personalitzada');
      expect(component.getTexts()['label'], equals('Etiqueta personalitzada'));
      
      // No es pot canviar el títol perquè és OnceSet
      // Però sí que canvia amb l'idioma
      L.setCurrentLocale(const Locale('en'));
      expect(component.getTexts()['title'], equals('Sabina Application'));
      
      // Restaurem l'idioma original
      L.setCurrentLocale(originalLocale);
    });
    
    test('Formulari amb etiquetes localitzables', () {
      // Guardem l'idioma original per restaurar-lo després
      final originalLocale = L.getCurrentLocale();
      
      // Establim un idioma conegut per a la prova
      L.setCurrentLocale(const Locale('ca'));
      
      // Creem un formulari
      final form = TestForm();
      form.addField('language', '##sChangeLanguage');
      form.addField('theme', '##sChangeTheme');
      
      // Verificar etiquetes en català
      expect(form.getLabelText('language'), equals('Canvia l\'Idioma'));
      expect(form.getLabelText('theme'), equals('Canvia el Tema'));
      
      // Assignar valors
      form.setValue('language', 'ca');
      form.setValue('theme', 'fosc');
      
      expect(form.getValue('language'), equals('ca'));
      expect(form.getValue('theme'), equals('fosc'));
      
      // Canviar l'idioma
      L.setCurrentLocale(const Locale('en'));
      
      // Verificar etiquetes en anglès
      expect(form.getLabelText('language'), equals('Change Language'));
      expect(form.getLabelText('theme'), equals('Change Theme'));
      
      // Els valors no es tradueixen
      expect(form.getValue('language'), equals('ca'));
      expect(form.getValue('theme'), equals('fosc'));
      
      // Restaurem l'idioma original
      L.setCurrentLocale(originalLocale);
    });
  });
}
