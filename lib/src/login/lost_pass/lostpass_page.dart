import 'package:duels/config/imports.dart';

class LostPassPage extends ConsumerWidget {

  const LostPassPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(lostPassProvider);
    final controller = ref.read(lostPassProvider.notifier);

    return Container(

      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(RADIUS), topRight: Radius.circular(RADIUS))
      ),
      clipBehavior: Clip.antiAlias,

      child: Scaffold(

        backgroundColor: COLOR_BACKGROUND,

        extendBody: true,

        appBar: AppBarClose(context: context, color: COLOR_BACKGROUND, showBottomBorder: false,),

        body: Loading(

          loading: state.loading,

          child: ListView(

            padding: PADDING_ALL,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),

            children: [

              TextBig("Recuperar contraseña", textAlign: TextAlign.center, maxlines: 5),

              Space(SPACE_MEDIUM),

              TextBody(
                "Introduce tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.",
                textAlign: TextAlign.center,
                maxlines: 5,
              ),

              Space(SPACE_MEDIUM),

              TextFieldCustom(
                controller: state.controllerEmail,
                labelText: "Correo electrónico",
                errorText: "Introduce un email",
                textInputType: TextInputType.emailAddress,
              ),

              Space(SPACE_BIG),

            ],
          ),
        ),

        bottomSheet: BottomSheetCustomOneButton(
          title: "Recuperar contraseña",
          onPressed: (){
            controller.recoverPassword(context);
          },
        ),
      ),

    );

  }
}

