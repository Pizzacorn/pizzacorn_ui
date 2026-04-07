import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class LoginFormCustomPage extends ConsumerWidget {
  final LoginCustomSuccessCallback? onAuthSuccess;

  // ignore: prefer_const_constructors_in_immutables
  LoginFormCustomPage({super.key, this.onAuthSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginCustomState state = ref.watch(loginCustomControllerProvider);
    final LoginCustomController controller = ref.read(
      loginCustomControllerProvider.notifier,
    );

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND_SECONDARY,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBarClose(
        context: context,
        showBottomBorder: false,
        color: COLOR_BACKGROUND.withValues(alpha: 0),
      ),
      body: Loading(
        loading: state.loading,
        child: Center(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: PADDING_ALL,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBig("Inicia sesion"),
                    TextBody("Inicia con tu cuenta"),
                    Space(SPACE_MEDIUM),
                    ButtonCustom(
                      text: "Continuar con Google",
                      iconBegin: "google",
                      colorGradientPrimary: COLOR_BACKGROUND,
                      colorGradientSecondary: COLOR_BACKGROUND,
                      color: COLOR_BACKGROUND,
                      padding: 10,
                      iconNoColor: true,
                      border: true,
                      onPressed: () {
                        controller.login(
                          context,
                          google: true,
                          onAuthSuccess: onAuthSuccess,
                        );
                      },
                    ),
                    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
                      Space(SPACE_SMALL),
                    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
                      ButtonCustom(
                        text: "Continuar con Apple",
                        color: COLOR_BACKGROUND,
                        border: true,
                        padding: 10,
                        iconBegin: "apple",
                        iconColor: COLOR_TEXT,
                        onPressed: () {
                          controller.login(
                            context,
                            apple: true,
                            onAuthSuccess: onAuthSuccess,
                          );
                        },
                      ),
                    Space(SPACE_MEDIUM),
                    Divider(),
                    Space(SPACE_MEDIUM),
                    TextFieldCustom(
                      controller: state.controllerEmail,
                      labelText: "Correo electronico",
                      colorFill: COLOR_BACKGROUND,
                      errorText: "Tienes que introducir un email",
                      textInputType: TextInputType.emailAddress,
                    ),
                    Space(SPACE_SMALL),
                    TextFieldCustom(
                      controller: state.controllerPassword,
                      labelText: "Contrasena",
                      colorFill: COLOR_BACKGROUND,
                      errorText: "Tienes que introducir una contrasena",
                      textInputType: TextInputType.text,
                      password: true,
                    ),
                    Space(SPACE_MEDIUM),
                    ButtonCustom(
                      text: "Iniciar sesion",
                      onPressed: () {
                        controller.login(
                          context,
                          password: true,
                          onAuthSuccess: onAuthSuccess,
                        );
                      },
                    ),
                    Space(SPACE_SMALL),
                    ButtonCustom(
                      text: "Has olvidado la contrasena?",
                      customSizeText: 12,
                      textColor: COLOR_SUBTEXT,
                      onlyText: true,
                      onPressed: () {
                        openBottomSheet(context, LostPassCustomPage());
                      },
                    ),
                    Space(SPACE_BIG),
                    ButtonCustom(
                      richTexts: [
                        {"": "Aun no tienes cuenta? "},
                        {"destacado": "Crear cuenta"},
                      ],
                      onPressed: () {
                        goTo(
                          context,
                          SignupFormCustomPage(onAuthSuccess: onAuthSuccess),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
