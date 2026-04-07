import 'package:duels/config/imports.dart';

class LostPassState {
  final bool loading;
  final TextEditingController controllerEmail;

  LostPassState({
    required this.loading,
    required this.controllerEmail,
  });

  LostPassState copyWith({bool? loading}) => LostPassState(
    loading: loading ?? this.loading,
    controllerEmail: controllerEmail,
  );
}

class LostPassController extends StateNotifier<LostPassState> {
  LostPassController()
      : super(LostPassState(
    loading: false,
    controllerEmail: TextEditingController(),
  ));

  void setLoading(bool value) => state = state.copyWith(loading: value);


  Future<void> recoverPassword(BuildContext context) async {
    if (state.controllerEmail.text.isEmpty) {
       openSnackbar(context, text: "Introduce un email válido");
      return;
    }

    setLoading(true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: state.controllerEmail.text);
      setLoading(false);
       openSnackbar(context, text: "Email de recuperación enviado", isDone: true);
      Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
      setLoading(false);
    }
  }


  @override
  void dispose() {
    state.controllerEmail.dispose();
    super.dispose();
  }
}

final lostPassProvider = StateNotifierProvider<LostPassController, LostPassState>((ref) {
  return LostPassController();
});
