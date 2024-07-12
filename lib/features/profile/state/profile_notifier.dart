import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/core/prefs/preferences_interface.dart';
import 'package:fresh/features/profile/state/profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final PreferencesInterface _preferences;

  ProfileNotifier(this._preferences) : super(ProfileState()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final phoneNumber = await _preferences.getString('phone_number');
    state = ProfileState(phoneNumber: phoneNumber);
  }

  Future<void> logout() async {
    await _preferences.setString('phone_number', '');
    state = ProfileState();
  }
}
