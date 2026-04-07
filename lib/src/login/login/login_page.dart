import 'package:duels/config/imports.dart';

class LoginPage extends ConsumerWidget {

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

    return Container(

      child: Scaffold(

        backgroundColor: COLOR_BACKGROUND_SECONDARY,
        extendBody: true,
        resizeToAvoidBottomInset: true,

        appBar: AppBarClose(context: context, showBottomBorder: false, color: COLOR_BACKGROUND.withValues(alpha: 0)),

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

                          TextBig("Inicia sesión"),

                          TextBody("Inicia con tu cuenta de Genima"),

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
                            onPressed: () => controller.login(context, google: true),
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
                              onPressed: () => controller.login(context, apple: true),
                            ),

                          Space(SPACE_MEDIUM),

                          Divider(),

                          Space(SPACE_MEDIUM),

                          TextFieldCustom(
                            controller: state.controllerEmail,
                            labelText: "Correo electrónico",
                            colorFill: COLOR_BACKGROUND,
                            errorText: "Tienes que introducir un email",
                            textInputType: TextInputType.emailAddress,
                          ),

                          Space(SPACE_SMALL),

                          TextFieldCustom(
                            controller: state.controllerPassword,
                            labelText: "Contraseña",
                            colorFill: COLOR_BACKGROUND,
                            errorText: "Tienes que introducir una contraseña",
                            textInputType: TextInputType.text,
                            password: true,
                          ),

                          Space(SPACE_MEDIUM),

                          ButtonCustom(
                            text: "Iniciar sesión",
                            onPressed: () => controller.login(context, password: true),
                          ),

                          Space(SPACE_SMALL),

                          ButtonCustom(
                            text: "¿Has olvidado la contraseña?",
                            customSizeText: 12,
                            textColor: COLOR_SUBTEXT,
                            onlyText: true,
                            onPressed: () {
                              openBottomSheet(context, LostPassPage());
                            },
                          ),

                          Space(SPACE_BIG),

                          ButtonCustom(
                            richTexts: const [
                              {"": "¿Aún no tienes cuenta? "},
                              {"destacado": "Crear cuenta"},
                            ],
                            onPressed: () {
                              goTo(context, SingupPage());
                            },
                          ),

                        ]
                    ),

                  ),



                ],

              ),

            )

        ),

      ),

    );

  }

}
