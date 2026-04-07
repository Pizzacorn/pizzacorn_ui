import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class LostPassCustomState {
  final bool loading;
  final TextEditingController controllerEmail;

  LostPassCustomState({required this.loading, required this.controllerEmail});

  LostPassCustomState copyWith({bool? loading}) {
    return LostPassCustomState(
      loading: loading ?? this.loading,
      controllerEmail: controllerEmail,
    );
  }
}

class LostPassCustomController extends StateNotifier<LostPassCustomState> {
  final LoginCustomAuthRepository loginAuthRepository =
      LoginCustomAuthRepository();

  LostPassCustomController()
    : super(
        LostPassCustomState(
          loading: false,
          controllerEmail: TextEditingController(),
        ),
      );

  void setLoading(bool value) => state = state.copyWith(loading: value);

  Future<void> recoverPassword(BuildContext context) async {
    if (state.controllerEmail.text.isEmpty) {
      openSnackbar(context, text: "Introduce un email valido");
      return;
    }

    setLoading(true);

    try {
      await loginAuthRepository.sendPasswordResetEmail(
        state.controllerEmail.text,
      );
      if (!context.mounted) {
        return;
      }
      setLoading(false);
      openSnackbar(
        context,
        text: "Email de recuperacion enviado",
        isError: false,
        isDone: true,
      );
      Navigator.pop(context);
    } catch (error) {
      if (context.mounted) {
        loginAuthRepository.showError(context, error);
      }
      setLoading(false);
    }
  }

  @override
  void dispose() {
    state.controllerEmail.dispose();
    super.dispose();
  }
}

final lostPassCustomProvider =
    StateNotifierProvider.autoDispose<
      LostPassCustomController,
      LostPassCustomState
    >((ref) {
      return LostPassCustomController();
    });
