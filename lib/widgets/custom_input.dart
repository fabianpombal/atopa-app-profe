import 'package:atopa_app_flutter/themes/input_decorations.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final Key? keyField;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextInputType? inputType;
  final bool password;
  final void Function(String) callback;
  final String? Function(String?)? validation;
  final FocusNode? focusNode;
  final IconData? icono;
  final IconButton? suffix;
  final bool? enable;
  final TextEditingController? controller;

  CustomInputField(
      {Key? key,
      required this.keyField,
      this.initialValue,
      required this.hintText,
      required this.labelText,
      required this.helperText,
      this.inputType,
      this.password = false,
      required this.callback,
      this.validation,
      this.focusNode,
      this.icono,
      this.suffix,
      this.controller,
      this.enable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable == null ? true : enable,
      key: this.keyField,
      initialValue: initialValue,
      autofocus: false,
      obscureText: password,
      keyboardType: inputType,
      textCapitalization: TextCapitalization.words,
      validator: validation,
      onChanged: callback,
      focusNode: focusNode,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecorations.authInputDecoration(
          hint: hintText, label: labelText!, helperText: helperText, icono: icono == null ? null : icono, suffix: suffix == null ? null : suffix),
    );
  }
}
