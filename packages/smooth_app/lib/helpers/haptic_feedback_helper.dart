import 'package:flutter/services.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';

/// Haptic feedback/vibrations in the app
/// Managed by a preference in the user's preferences
class SmoothHapticFeedback {
  const SmoothHapticFeedback._();

  /// Will vibrate smoothly twice
  static Future<void> confirm() async {
    if (!(await _areHapticFeedbackEnabled())) {
      return;
    }

    await HapticFeedback.lightImpact();
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
      HapticFeedback.lightImpact();
    });
  }

  /// Discrete vibration
  static Future<void> click() async {
    if (!(await _areHapticFeedbackEnabled())) {
      return;
    }

    return HapticFeedback.selectionClick();
  }

  /// According to the doc: "a collision impact with a light mass"
  static Future<void> lightNotification() async {
    if (!(await _areHapticFeedbackEnabled())) {
      return;
    }

    return HapticFeedback.lightImpact();
  }

  /// Same as [lightNotification] but played twice
  static Future<void> lightNotificationTwice() async {
    if (!(await _areHapticFeedbackEnabled())) {
      return;
    }

    await HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return HapticFeedback.lightImpact();
  }

  /// Will vibrate heavily twice
  static Future<void> error() async {
    if (!(await _areHapticFeedbackEnabled())) {
      return;
    }

    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return HapticFeedback.heavyImpact();
  }

  static Future<void> tadam() async {
    if (!(await _areHapticFeedbackEnabled())) {
      return;
    }

    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return HapticFeedback.heavyImpact();
  }

  static Future<bool> _areHapticFeedbackEnabled() async {
    return UserPreferences.getUserPreferences().then((
      UserPreferences userPreferences,
    ) {
      return userPreferences.hapticFeedbackEnabled;
    });
  }
}
