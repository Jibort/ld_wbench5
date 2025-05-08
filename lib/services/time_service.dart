// lib/services/time_service.dart
// Servei per obtenir l'hora exacta d'un servidor horari
// Created: 2025/05/08 dj.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Model de dades de l'hora del servidor
class TimeModel extends LdModelAbs {
  DateTime _currentTime = DateTime.now();
  DateTime get currentTime => _currentTime;
  
  /// Actualitza l'hora i notifica als observadors
  void updateTime(DateTime newTime) {
    notifyListeners(() {
      _currentTime = newTime;
      Debug.info("$tag: Hora actualitzada a ${formatTime(newTime)}");
    });
  }
  
  /// Formata l'hora en format HH:mm:ss
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }
  
  /// Retorna l'hora actual formatada
  String get formattedTime => formatTime(_currentTime);
  
  /// Retorna l'hora actual formatada amb text descriptiu
  String getFormattedWithText(String text) {
    return "$text ${formatTime(_currentTime)}";
  }
}

/// Servei per obtenir l'hora exacta d'un servidor horari
class TimeService with LdTaggableMixin {
  /// Instància singleton
  static final TimeService _inst = TimeService._();
  static TimeService get s => _inst;
  
  /// Model de dades amb l'hora actual
  final TimeModel _model = TimeModel();
  
  /// Retorna el model de dades
  TimeModel get model => _model;
  
  /// Timer per actualitzar l'hora periòdicament
  Timer? _timer;
  
  /// Constructor privat
  TimeService._() {
    tag = className;
    _model.tag = "${tag}_Model";
    Debug.info("$tag: Inicialitzant servei d'hora");
    initialize();
  }
  
  /// Inicialitza el servei
  void initialize() {
    fetchTimeFromServer(); // Primer obtenim l'hora del servidor
    
    // Configurem un timer per actualitzar cada mig segon
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _updateLocalTime();
    });
    
    // Cada 30 segons sincronitzem amb el servidor
    Timer.periodic(const Duration(seconds: 30), (_) {
      fetchTimeFromServer();
    });
  }
  
  /// Atura el servei quan ja no és necessari
  void dispose() {
    _timer?.cancel();
    _timer = null;
    Debug.info("$tag: Servei aturat");
  }
  
  /// Actualitza l'hora localment basant-se en l'última hora rebuda del servidor
  void _updateLocalTime() {
    final now = DateTime.now();
    
    // Si els segons han canviat, notifiquem
    if (now.second != _model.currentTime.second) {
      _model.updateTime(now);
    }
  }
  
  /// Obtenir l'hora del servidor (simulat)
  /// En una implementació real, es faria una crida a un servidor NTP o similar
  Future<void> fetchTimeFromServer() async {
    Debug.info("$tag: Sol·licitant hora del servidor...");
    
    try {
      // WorldTimeAPI proporciona l'hora actual segons la zona horària
      final response = await http.get(
        Uri.parse('http://worldtimeapi.org/api/timezone/Europe/Madrid')
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dateTime = DateTime.parse(data['datetime']);
        
        Debug.info("$tag: Hora rebuda del servidor: ${TimeModel.formatTime(dateTime)}");
        _model.updateTime(dateTime);
      } else {
        Debug.error("$tag: Error en obtenir hora del servidor. Codi: ${response.statusCode}");
        // En cas d'error, actualitzem amb l'hora local
        _model.updateTime(DateTime.now());
      }
    } catch (e) {
      Debug.error("$tag: Excepció en obtenir hora: $e");
      
      // En cas d'excepció, actualitzem amb l'hora local
      // Això és important per mantenir l'aplicació funcionant fins i tot sense connexió
      _model.updateTime(DateTime.now());
    }
  }
}