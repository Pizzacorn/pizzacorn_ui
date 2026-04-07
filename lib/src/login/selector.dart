import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

typedef LoginCustomSuccessCallback =
    FutureOr<void> Function(BuildContext context, User? user);

typedef LoginCustomGuestCallback =
    FutureOr<void> Function(BuildContext context);

class LoginCustomPage extends StatelessWidget {
  final String logoAsset;
  final String? logoPackage;
  final LoginCustomSuccessCallback? onAuthSuccess;
  final LoginCustomGuestCallback? onGuestPressed;
  final bool showGuestButton;
  final String createAccountText;
  final String loginText;
  final String alreadyHaveAccountText;
  final String guestText;

  // ignore: prefer_const_constructors_in_immutables
  LoginCustomPage(
    this.logoAsset, {
    super.key,
    this.logoPackage,
    this.onAuthSuccess,
    this.onGuestPressed,
    this.showGuestButton = true,
    this.createAccountText = "Crear una cuenta",
    this.loginText = "Iniciar sesion",
    this.alreadyHaveAccountText = "Ya tienes una cuenta?",
    this.guestText = "Entrar como invitado",
  });

  @override
  Widget build(BuildContext context) {
    final bool canShowGuestButton = showGuestButton && onGuestPressed != null;

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: COLOR_BACKGROUND_SECONDARY.withValues(alpha: 0),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundLottieCustom(
            isBlurred: true,
            sigmaX: 230,
            sigmaY: 230,
            type: PizzacornBackground.silver,
            fit: BoxFit.cover,
          ),
          Center(
            child: ListView(
              padding: PADDING,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                Space(100),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    logoAsset,
                    package: logoPackage,
                    width: 250,
                  ),
                ),
                Space(SPACE_MEDIUM),
                ButtonCustom(
                  text: createAccountText,
                  onPressed: () {
                    openBottomSheet(
                      context,
                      SignupFormCustomPage(onAuthSuccess: onAuthSuccess),
                      height: 600,
                    );
                  },
                ),
                Space(SPACE_BIG),
                Space(SPACE_BIG),
                TextBody(alreadyHaveAccountText, textAlign: TextAlign.center),
                Space(SPACE_MEDIUM),
                ButtonCustom(
                  text: loginText,
                  borderColor: COLOR_TEXT,
                  color: COLOR_BACKGROUND,
                  border: true,
                  onPressed: () {
                    openBottomSheet(
                      context,
                      LoginFormCustomPage(onAuthSuccess: onAuthSuccess),
                      height: 600,
                    );
                  },
                ),
                if (canShowGuestButton) Space(SPACE_BIG),
                if (canShowGuestButton)
                  ButtonCustom(
                    text: guestText,
                    textColor: COLOR_ACCENT,
                    onlyText: true,
                    onPressed: () async {
                      if (onGuestPressed != null) {
                        await onGuestPressed!(context);
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectorCustomPage extends LoginCustomPage {
  SelectorCustomPage({
    super.key,
    String logoAsset = "assets/icon/logo.png",
    super.logoPackage,
    super.onAuthSuccess,
    super.onGuestPressed,
    super.showGuestButton,
  }) : super(logoAsset);
}
