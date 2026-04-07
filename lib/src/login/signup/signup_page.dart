import 'package:duels/config/imports.dart';

class SingupPage extends ConsumerWidget {
  const SingupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(signupControllerProvider);
    final controller = ref.read(signupControllerProvider.notifier);

    return Scaffold(

      backgroundColor: COLOR_BACKGROUND_SECONDARY,
      extendBody: true,
      resizeToAvoidBottomInset: true,

      appBar: AppBarClose(context: context, showBottomBorder: false, color: COLOR_BACKGROUND.withValues(alpha: 0)),

      body: LoadingCustom(

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

                      TextBig("Crear una cuenta", textAlign: TextAlign.center),

                      TextBody("Crea tu cuenta de Genima"),

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
                        onPressed: () => controller.signup(context, google: true),
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
                          onPressed: () => controller.signup(context, apple: true),
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

                      Space(SPACE_SMALL),

                      CheckboxPolitics(
                        onTap: controller.toggleAccepted,
                        value: state.accepted,
                      ),

                      Space(SPACE_MEDIUM),

                      ButtonCustom(
                        text: "Crear cuenta",
                        onPressed: () => controller.signup(context, password: true),
                      ),



                      Space(SPACE_BIG),

                      ButtonCustom(
                        richTexts: const [
                          {"": "¿Ya tienes cuenta? "},
                          {"destacado": "Inicia sesión"},
                        ],
                        onPressed: () {
                          goTo(context, LoginPage());
                        },
                      ),

                    ]
                ),

              ),

            ],

          ),

        )

      ),

    );

  }

}


