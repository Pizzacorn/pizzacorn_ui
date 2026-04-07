import 'package:duels/config/imports.dart';

class LoginHeroWidget extends StatelessWidget {
  const LoginHeroWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Hero(
      tag: "login",
      child: Container(
          height: 200,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: COLOR_BACKGROUND_SECONDARY,
          ),
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
                child: Image.asset("assets/icon/logo.png"),
              ),
            ],
          )

      ),
    );
  }
}
