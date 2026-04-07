import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class LostPassCustomPage extends ConsumerWidget {
  // ignore: prefer_const_constructors_in_immutables
  LostPassCustomPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LostPassCustomState state = ref.watch(lostPassCustomProvider);
    final LostPassCustomController controller = ref.read(
      lostPassCustomProvider.notifier,
    );

    return Container(
      height: 400,
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
        body: Loading(
          loading: state.loading,
          child: ListView(
            padding: PADDING_ALL,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              TextBig(
                "Recuperar contrasena",
                textAlign: TextAlign.center,
                maxlines: 5,
              ),
              Space(SPACE_MEDIUM),
              TextBody(
                "Introduce tu correo electronico y te enviaremos un enlace para restablecer tu contrasena.",
                textAlign: TextAlign.center,
                maxlines: 5,
              ),
              Space(SPACE_MEDIUM),
              TextFieldCustom(
                controller: state.controllerEmail,
                labelText: "Correo electronico",
                errorText: "Introduce un email",
                textInputType: TextInputType.emailAddress,
              ),
              Space(SPACE_BIG),
            ],
          ),
        ),
        bottomSheet: BottomSheetCustomOneButton(
          title: "Recuperar contrasena",
          onPressed: () {
            controller.recoverPassword(context);
          },
        ),
      ),
    );
  }
}
