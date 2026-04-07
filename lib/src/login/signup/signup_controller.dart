import 'package:duels/config/imports.dart';

class SignupState {
  final bool loading;
  final bool accepted;
  final bool isEmailVerifying;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;

  SignupState({
    this.loading = false,
    this.accepted = false,
    this.isEmailVerifying = false,
    required this.controllerEmail,
    required this.controllerPassword,
  });

  SignupState copyWith({
    bool? loading,
    bool? accepted,
    bool? isEmailVerifying,
  }) =>
      SignupState(
        loading: loading ?? this.loading,
        accepted: accepted ?? this.accepted,
        isEmailVerifying: isEmailVerifying ?? this.isEmailVerifying,
        controllerEmail: controllerEmail,
        controllerPassword: controllerPassword,
      );
}

final signupControllerProvider = StateNotifierProvider.autoDispose<SignupController, SignupState>((ref) {
  return SignupController();
});

class SignupController extends StateNotifier<SignupState> {
  Timer? timer;

  SignupController()
      : super(SignupState(
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

  void toggleAccepted() => state = state.copyWith(accepted: !state.accepted);
  void setLoading(bool value) => state = state.copyWith(loading: value);
  void setVerifying(bool value) => state = state.copyWith(isEmailVerifying: value);

  Future<void> signup(BuildContext context, {bool google = false, bool password = false, bool apple = false}) async {
    if (!state.accepted && password) {
      openSnackbar(context, text: "Debes aceptar los términos y condiciones");
      return;
    }

    UserCredential? userCredential;
    setLoading(true);

    try {
      if (google) {
        userCredential = await AuthRepository().firebaseGoogleLogin(context);
      } else if (apple) {
        userCredential = await AuthRepository().firebaseAppleLogin(context);
      } else if (password) {
        if (state.controllerEmail.text.isNotEmpty && state.controllerPassword.text.isNotEmpty) {
          userCredential = await AuthRepository().firebaseRegister(context, state.controllerEmail.text, state.controllerPassword.text);
        } else {
          // Validación rápida para mostrar error en campos
          if (state.controllerEmail.text.isEmpty) {
            state.controllerEmail.text = " ";
            state.controllerEmail.clear();
          }
          if (state.controllerPassword.text.isEmpty) {
            state.controllerPassword.text = " ";
            state.controllerPassword.clear();
          }
          setLoading(false);
          return;
        }
      }

      if (userCredential == null) {
        setLoading(false);
        return;
      }

      final user = FirebaseAuth.instance.currentUser;

      // 🛡️ LÓGICA DE VERIFICACIÓN (Igual que en Login)
      if (user != null && !user.emailVerified) {
        setLoading(false);
        setVerifying(true);

        // Enviamos el correo de verificación
        await user.sendEmailVerification();

        // Abrimos el BottomSheet de verificación
        openBottomSheet(context, const VerifyEmailPage());

        // Iniciamos el polling para detectar cuando confirme
        startVerificationTimer(context);
        return;
      }

      // Si ya está verificado (Social Login) o no necesita verificación
      await AuthRepository().checkUser(context, user: user);
      setLoading(false);

    } catch (error) {
      debugPrint("Error en signup: $error");
      openSnackbar(context, text: "Ocurrió un error al registrarte");
      setLoading(false);
    }
  }

  void startVerificationTimer(BuildContext context) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), (t) async {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();

      if (user != null && user.emailVerified) {
        t.cancel();
        setVerifying(false);

        // Cerramos el BottomSheet de VerifyEmailPage
        if (Navigator.canPop(context)) goBack(context);

        // Proceso de entrada al App/Onboarding
        await AuthRepository().checkUser(context, user: user);
      }
    });
  }
}
