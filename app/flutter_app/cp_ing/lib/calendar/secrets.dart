import 'dart:io' show Platform;

class Secret {
  static const androidClientId = "482736807178-jh0rvhabepk03iv28aftbmd2u20vv1e3.apps.googleusercontent.com";
  static String getId() => Platform.isAndroid ? Secret.androidClientId : "null";
}