import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class VerifyEmailCustomPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  VerifyEmailCustomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(RADIUS),
          topRight: Radius.circular(RADIUS),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        extendBody: true,
        appBar: AppBarClose(
          context: context,
          color: COLOR_BACKGROUND,
          showBottomBorder: false,
        ),
        body: ListView(
          padding: PADDING_ALL,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            TextBig("Verifica tu email", textAlign: TextAlign.center),
            Space(SPACE_MEDIUM),
            TextBody(
              "Te hemos enviado un correo para verificar tu email. Revisa la carpeta de spam si no lo encuentras.",
              textAlign: TextAlign.center,
              maxlines: 5,
            ),
            Space(SPACE_MEDIUM),
          ],
        ),
        bottomSheet: BottomSheetCustomOneButton(
          title: "Entendido",
          onPressed: () {
            goBack(context);
          },
        ),
      ),
    );
  }
}
