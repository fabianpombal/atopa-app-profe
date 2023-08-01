import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String? hint, required String label, IconData? icono, IconButton? suffix, String? helperText}) {
    return InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(13, 96, 254, 1), width: 2)),
        hintText: hint,
        labelText: label,
        helperText: helperText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16
        ),
        prefixIcon: icono != null ? Icon(icono) : null,
        suffixIcon: suffix);
  }
}
