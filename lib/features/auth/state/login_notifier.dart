import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/core/prefs/preferences_interface.dart';
import 'package:fresh/features/auth/state/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final PreferencesInterface _preferences;

  LoginNotifier(this._preferences) : super(LoginState());

  Future<void> login(String phoneNumber) async {
    state = LoginState(isLoading: true);
    try {
      // Simulating OTP verification
      await Future.delayed(const Duration(seconds: 2));
      await _preferences.setString('phone_number', phoneNumber);
      state = LoginState();
    } catch (e) {
      state = LoginState(error: e.toString());
    }
  }
}
