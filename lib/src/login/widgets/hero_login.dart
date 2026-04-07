import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class LoginHeroCustomWidget extends StatelessWidget {
  final String logoAsset;
  final String? logoPackage;

  // ignore: prefer_const_constructors_in_immutables
  LoginHeroCustomWidget({super.key, required this.logoAsset, this.logoPackage});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "login",
      child: Container(
        height: 200,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: COLOR_BACKGROUND_SECONDARY),
        child: Stack(
          alignment: Alignment.center,
          children: [
            BackgroundLottieCustom(
              isBlurred: true,
              sigmaY: 230,
              sigmaX: 230,
              type: PizzacornBackground.silver,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              width: 220,
              child: Image.asset(logoAsset, package: logoPackage),
            ),
          ],
        ),
      ),
    );
  }
}
