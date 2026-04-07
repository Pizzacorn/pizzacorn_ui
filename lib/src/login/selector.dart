import 'package:duels/config/imports.dart';
import 'package:duels/widgets/background.dart';

class SelectorPage extends StatefulWidget {
  const SelectorPage({super.key});

  @override
  State<SelectorPage> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {

  @override
  Widget build(BuildContext context) {

    final String currentLang = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';

    return Scaffold(

      backgroundColor: COLOR_BACKGROUND,

      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(backgroundColor: COLOR_BACKGROUND_SECONDARY.withValues(alpha: 0), automaticallyImplyLeading: false,),

      body: Container(

          child: Stack(

            fit: StackFit.expand,

            children: [

              BackgroundWithImageCustom(),

              Center(

                child: ListView(

                  padding: PADDING,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),

                  children: [

                    Space(100),

                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/icon/logo.png", width: 250,),
                    ),

                    Space(SPACE_MEDIUM),

                    ButtonCustom(
                        text: "Crear una cuenta",
                        onPressed: (){
                          openBottomSheet(context, height: 600, SingupPage());
                        }
                    ),

                    Space(SPACE_BIG),

                    Space(SPACE_BIG),

                    TextBody("¿Ya tienes una cuenta?", textAlign: TextAlign.center),

                    Space(SPACE_MEDIUM),

                    ButtonCustom(
                        text: "Iniciar sesión",
                        borderColor: COLOR_TEXT,
                        color: COLOR_BACKGROUND,
                        border: true,
                        onPressed: (){
                          openBottomSheet(context, height: 600, LoginPage());
                        }
                    ),

                    Space(SPACE_BIG),

                    ButtonCustom(
                      text: "Entrar como invitado",
                      textColor: COLOR_ACCENT,
                      onlyText: true,
                      onPressed: () {
                        goTo(context, HomePage());
                      },
                    ),


                  ],

                ),

              ),

            ],

          )

        ),

    );

  }

}
