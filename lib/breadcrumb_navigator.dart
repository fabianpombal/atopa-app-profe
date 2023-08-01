import 'package:atopa_app_flutter/app_navigator_observer.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class BreadCrumbNavigator extends StatelessWidget {
  final List < Route > currentRouteStack;

  BreadCrumbNavigator(): this.currentRouteStack = routeStack.toList();

  @override
  Widget build(BuildContext context) {
    return RowSuper(
      children: List < Widget > .from(currentRouteStack
        .asMap()
        .map(
          (index, value) => MapEntry(
            index,
            currentRouteStack[index].settings.arguments != null ?
            (index != currentRouteStack.length - 1 ?
              InkWell(
                onTap: () {
                  Navigator.popUntil(context,
                    (route) => route == currentRouteStack[index]);
                },
                child: _BreadButton(
                  (currentRouteStack[index].settings.arguments!as Map < String, dynamic > )['menu'] !,
                  index == 0, index == currentRouteStack.length - 1)
              ) : Container(
                child: _BreadButton(
                  (currentRouteStack[index].settings.arguments!as Map < String, dynamic > )['menu'] !,
                  index == 0, index == currentRouteStack.length - 1)
              )) : Container()
          ),
        )
        .values),
      // mainAxisSize: MainAxisSize.max,
      innerDistance: -16,
    );
  }
}

class _BreadButton extends StatelessWidget {
  final String text;
  final bool isFirstButton;
  final bool lastButton;

  _BreadButton(this.text, this.isFirstButton, this.lastButton);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TriangleClipper(!isFirstButton),
      child: Container(
        color: this.lastButton ? CustomTheme.atopaGreyDark : CustomTheme.atopaBlue,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: isFirstButton ? 8 : 20, end: 28, top: 8, bottom: 8),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper < Path > {
  final bool twoSideClip;

  _TriangleClipper(this.twoSideClip);

  @override
  Path getClip(Size size) {
    final Path path = new Path();
    if (twoSideClip) {
      path.moveTo(20, 0.0);
      path.lineTo(0.0, size.height / 2);
      path.lineTo(20, size.height);
    } else {
      path.lineTo(0, size.height);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper < Path > oldClipper) {
    return true;
  }
}