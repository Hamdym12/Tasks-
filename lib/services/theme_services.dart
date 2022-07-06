// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {

  final GetStorage _box = GetStorage();
  final _key="IsDarkMode";

   _SaveThemeToBox(bool IsDarkMode){
     _box.write(_key, IsDarkMode);
   }

 bool _loadThemeformBox()=> _box.read<bool>(_key) ?? false;

  ThemeMode get theme => _loadThemeformBox() ? ThemeMode.dark : ThemeMode.light;

  void SwitchTheme(){
    Get.changeThemeMode(_loadThemeformBox() ? ThemeMode.light : ThemeMode.dark);
    _SaveThemeToBox(!_loadThemeformBox());
  }
}
