import 'package:flutter/foundation.dart';

class ColoredLogs{
  static void error(String message){
    if(kDebugMode) {
      print('\x1B[31m$message\x1B[0m');
    }
  }

  static void info(String message){
    if(kDebugMode) {
      print('\x1B[34m$message\x1B[0m');
    }
  }

  static void success(String message){
    if(kDebugMode) {
      print('\x1B[32m$message\x1B[0m');
    }
  }

  static void debug(String message){
    if(kDebugMode) {
      print('\x1B[33m$message\x1B[0m');
    }
  }
}