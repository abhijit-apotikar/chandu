import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

//-------------- my packages ----------------------------
import '../models/colorCodeNotifier.dart';
import '../models/colorCodeModel.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorCodeNotifier _colorCodeNotifier =
        Provider.of<ColorCodeNotifier>(context);
    ColorCodeModel localColorCode = _colorCodeNotifier.getColorCode();
    return Container(
      child: Center(
        child: SpinKitCircle(
          color: localColorCode.loadingSpinnerColor,
          size: 80,
        ),
      ),
    );
  }
}
