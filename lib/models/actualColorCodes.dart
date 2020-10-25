import 'package:flutter/material.dart';
import '../models/colorCodeModel.dart';

final lightTheme = new ColorCodeModel(
  backGroundColor1: Color(0xffb2ff59),
  backGroundColor2: Color(0xff69f0ae),
  cardColor: Colors.white,
  textColor1: Colors.black,
  textColor2: Colors.redAccent,
  textColor3: Colors.black54,
  transparentCard: Colors.transparent,
  loadingSpinnerColor: Colors.black,
  optionCardColor: Colors.white,
  toastTextColor: Colors.white,
  toastBackgroundColor: Colors.black,
  topperListCardColor: Colors.white,
);

final darkTheme = new ColorCodeModel(
  backGroundColor1: Colors.black,
  backGroundColor2: Colors.black,
  cardColor: Colors.grey[850],
  textColor1: Colors.white,
  textColor2: Colors.redAccent,
  textColor3: Colors.white54,
  transparentCard: Colors.grey[850],
  loadingSpinnerColor: Colors.green,
  optionCardColor: Colors.grey,
  toastTextColor: Colors.black,
  toastBackgroundColor: Colors.white,
  topperListCardColor: Colors.grey[700],
);
