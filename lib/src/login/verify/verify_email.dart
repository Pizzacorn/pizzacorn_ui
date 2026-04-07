import 'package:duels/config/imports.dart';

class VerifyEmailPage extends StatefulWidget {

  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {


  GlobalKey<ScaffoldState> key = GlobalKey();
  bool loading = false;

  final controllerEmail = TextEditingController();

  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Container(

      height: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(RADIUS), topRight: Radius.circular(RADIUS))
      ),
      clipBehavior: Clip.antiAlias,

      child: Scaffold(

        backgroundColor: COLOR_BACKGROUND,

        extendBody: true,

        appBar: AppBarClose(context: context, color: COLOR_BACKGROUND, showBottomBorder: false,),

        body: ListView(

          padding: PADDING_ALL,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),

          children: [

            TextBig("Verifica tu email", textAlign: TextAlign.center, maxlines: 5),

            Space(SPACE_MEDIUM),

            TextBody(
              "Te hemos enviado un correo para verificar tu email. Revisa en tu carpeta de Spam si no encuentras el email.",
              textAlign: TextAlign.center,
              maxlines: 5,
            ),

            Space(SPACE_MEDIUM),

          ],
        ),

        bottomSheet: BottomSheetCustomOneButton(
          title: "Entendido",
          onPressed: (){
            goBack(context);
          },
        ),
      ),


    );


  }


  recuperarPass(){

    if(controllerEmail.text.isNotEmpty){

      setState(() {loading = true;});


      try{

        FirebaseAuth.instance.sendPasswordResetEmail(email: controllerEmail.text).whenComplete((){

          setState(() {loading = false;});
           openSnackbar(context, text: "Email de recuperación enviado", color: COLOR_DONE);
          Navigator.pop(context);


        });


      }catch(error){

        debugPrint(error.toString());
        setState(() {loading = false;});

      }

    }else{

      if(controllerEmail.text.isEmpty){
        setState(() {
          controllerEmail.text = " ";
          controllerEmail.clear();
        });
      }

    }


  }

}
