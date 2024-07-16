import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/core/prefs/preferences_interface.dart';
import 'package:fresh/core/utils/connectivity_notifier.dart';
import 'package:fresh/features/auth/state/login_state.dart';

import 'package:fresh/core/utils/connectivity.dart';
import 'package:logger/logger.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final PreferencesInterface _preferences;
  final Logger _logger;

  LoginNotifier(this._preferences, this._logger) : super(LoginState());

  Future<void> login(String phoneNumber) async {
    state = LoginState(isLoading: true);
    try {
      if (await isConnected()) {
        // Simulating OTP verification
        await Future.delayed(const Duration(seconds: 2));
        await _preferences.setString('phone_number', phoneNumber);
        final phoneNumber1 = await _preferences.getString('phone_number');
        _logger.d('login $phoneNumber1');
        state = LoginState();
      } else {
        state = LoginState(error: 'No internet connection. Please try again when online.');
      }
    } catch (e) {
      state = LoginState(error: e.toString());
    }
  }
}