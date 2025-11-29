import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/local_storage/local_storage.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));
  ThemeMode themeMode = ThemeMode.dark;

  void changeThemeMode(ThemeMode mode) async {
    // await LocalStorage.instance.setString("themeMode", mode.name);
    themeMode = mode;
    emit(ThemeState(themeMode: themeMode));
  }

  static get savedThemeMode {
    // switch (LocalStorage.instance.getString("themeMode")) {
    //   case 'dark':
    //     return ThemeMode.dark;
    //   case 'light':
    //     return ThemeMode.light;
    //   case 'system':
    //   default:
    //     return ThemeMode.dark;
    // }
    return ThemeMode.light;
  }
}
