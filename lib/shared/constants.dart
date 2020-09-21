import 'package:flutter/material.dart';

const textFormFieldDecoration = InputDecoration(

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
      width: 2,
    ),
  ),
);

const myTextFormFieldTextStyle = TextStyle(
  fontFamily: 'Typewriter',
);