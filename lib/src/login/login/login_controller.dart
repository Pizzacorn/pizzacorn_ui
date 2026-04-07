import 'package:duels/config/imports.dart';

class LoginState {
  final bool loading;
  final bool isEmailVerifying; // Para saber si mostramos el aviso de verificar email
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;

  LoginState({
    this.loading = false,
    this.isEmailVerifying = false,
    required this.controllerEmail,
    required this.controllerPassword,
  });

  LoginState copyWith({
    bool? loading,
    bool? isEmailVerifying,
  }) => LoginState(
    loading: loading ?? this.loading,
    isEmailVerifying: isEmailVerifying ?? this.isEmailVerifying,
    controllerEmail: controllerEmail,
    controllerPassword: controllerPassword,
  );
}


final loginControllerProvider = StateNotifierProvider.autoDispose<LoginController, LoginState>((ref) {
  return LoginController();
});

class LoginController extends StateNotifier<LoginState> {
  Timer? timer;

  LoginController() : super(LoginState(
    controllerEmail: TextEditingController(),
    controllerPassword: TextEditingController(),
  ));

  @override
  void dispose() {
    timer?.cancel();
    state.controllerEmail.dispose();
    state.controllerPassword.dispose();
    super.dispose();
  }

  setLoading(bool value) => state = state.copyWith(loading: value);
  setVerifying(bool value) => state = state.copyWith(isEmailVerifying: value);

  login(BuildContext context, {bool google = false, bool password = false, bool apple = false}) async {
    UserCredential? userCredential;
    setLoading(true);

    try {
      if (google) {
        userCredential = await AuthRepository().firebaseGoogleLogin(context);
      } else if (apple) {
        userCredential = await AuthRepository().firebaseAppleLogin(context);
      } else if (password) {
        if (state.controllerEmail.text.isNotEmpty && state.controllerPassword.text.isNotEmpty) {
          userCredential = await AuthRepository().firebaseLogin(context, state.controllerEmail.text, state.controllerPassword.text);
        }
      }

      if (userCredential == null) {
        setLoading(false);
        return;
      }

      // 🛡️ VERIFICACIÓN DE EMAIL
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        setLoading(false);
        setVerifying(true);

        // Enviamos el correo de verificación por si acaso no le llegó
        await user.sendEmailVerification();

        // Abrimos el aviso (BottomSheet)
        openBottomSheet(context, VerifyEmailPage(), height: 300);

        // Iniciamos el "listener" manual con Timer
        startVerificationTimer(context);
        return;
      }

      // Si ya está verificado o es social login (que suelen venir verificados)
      await AuthRepository().checkUser(context, user: userCredential.user);
      setLoading(false);

    } catch (e) {
      debugPrint(e.toString());
      setLoading(false);
    }
  }

  void startVerificationTimer(BuildContext context) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), (t) async {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload(); // Crucial: refresca el estado del usuario

      if (user != null && user.emailVerified) {
        t.cancel();
        setVerifying(false);

        // Cerramos el BottomSheet si sigue abierto
        if (Navigator.canPop(context)) goBack(context);

        // Al Onboarding!
        await AuthRepository().checkUser(context, user: user);
      }
    });
  }

}

