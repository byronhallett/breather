import "package:flutter/services.dart";

class Vibration {
  Vibration._();
  static void vibrate() {
    vibrateRecursive(Duration(milliseconds: 100), 24);
  }

  static void vibrateRecursive(Duration delay, int times) {
    if (times <= 0) {
      return;
    }
    HapticFeedback.vibrate().timeout(delay).then((_) {
      vibrateRecursive(delay, times - 1);
    });
  }
}
