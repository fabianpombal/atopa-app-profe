import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  const CardContainer({Key? key, required this.child, required this.color, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 200),
      child: Container(
        padding: EdgeInsets.all(20),
        width: this.width,
        decoration: _createCardShape(this.color),
        child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: CustomTheme.atopaGrey, width: 2),
        boxShadow: const [
          BoxShadow(
              color: CustomTheme.atopaGreyTrans, blurRadius: 15)
        ]);
  }
}
