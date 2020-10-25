import 'package:flutter/material.dart';
import '../models/colorCodeModel.dart';

class ColorCodeNotifier with ChangeNotifier {
  ColorCodeModel _colorCodeModel;
  ColorCodeNotifier(this._colorCodeModel);
  getColorCode() => _colorCodeModel;
  setColorCode(ColorCodeModel colorCodeModel) async {
    _colorCodeModel = colorCodeModel;
    notifyListeners();
  }
}
