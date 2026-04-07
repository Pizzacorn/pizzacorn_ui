import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class SignupCustomState {
  final bool loading;
  final bool accepted;
  final bool isEmailVerifying;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;

  SignupCustomState({
    this.loading = false,
    this.accepted = false,
    this.isEmailVerifying = false,
    required this.controllerEmail,
    required this.controllerPassword,
  });

  SignupCustomState copyWith({
    bool? loading,
    bool? accepted,
    bool? isEmailVerifying,
  }) {
    return SignupCustomState(
      loading: loading ?? this.loading,
      accepted: accepted ?? this.accepted,
      isEmailVerifying: isEmailVerifying ?? this.isEmailVerifying,
      controllerEmail: controllerEmail,
      controllerPassword: controllerPassword,
    );
  }
}

final signupCustomControllerProvider =
    StateNotifierProvider.autoDispose<
      SignupCustomController,
      SignupCustomState
    >((ref) {
      return SignupCustomController();
    });

class SignupCustomController extends StateNotifier<SignupCustomState> {
  Timer? timer;
  final LoginCustomAuthRepository loginAuthRepository =
      LoginCustomAuthRepository();

  SignupCustomController()
    : super(
        SignupCustomState(
          controllerEmail: TextEditingController(),
          controllerPassword: TextEditingController(),
        ),
      );

  @override
  void dispose() {
    timer?.cancel();
    state.controllerEmail.dispose();
    state.controllerPassword.dispose();
    super.dispose();
  }

  void toggleAccepted() => state = state.copyWith(accepted: !state.accepted);

  void setLoading(bool value) => state = state.copyWith(loading: value);

  void setVerifying(bool value) {
    state = state.copyWith(isEmailVerifying: value);
  }

  Future<void> signup(
    BuildContext context, {
    bool google = false,
    bool password = false,
    bool apple = false,
    LoginCustomSuccessCallback? onAuthSuccess,
  }) async {
    if (!state.accepted && password) {
      openSnackbar(context, text: "Debes aceptar los terminos y condiciones");
      return;
    }

    UserCredential? userCredential;
    setLoading(true);

    try {
      if (google) {
        userCredential = await loginAuthRepository.loginWithGoogle(context);
      } else if (apple) {
        userCredential = await loginAuthRepository.loginWithApple();
      } else if (password) {
        if (state.controllerEmail.text.isEmpty ||
            state.controllerPassword.text.isEmpty) {
          // ⚠️ Validacion rapida para mostrar error en campos.
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

        userCredential = await loginAuthRepository.registerWithEmail(
          email: state.controllerEmail.text,
          password: state.controllerPassword.text,
        );
      }

      if (userCredential == null) {
        setLoading(false);
        return;
      }

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        setLoading(false);
        setVerifying(true);

        // 📩 Enviamos el correo de verificacion.
        await loginAuthRepository.sendVerificationEmail();
        if (!context.mounted) {
          return;
        }

        // 🍕 Abrimos el bottom sheet de verificacion.
        openBottomSheet(context, VerifyEmailCustomPage());

        // ⏱️ Detectamos cuando el usuario confirma su email.
        startVerificationTimer(context, onAuthSuccess: onAuthSuccess);
        return;
      }

      if (!context.mounted) {
        return;
      }
      await finishAuth(context, user, onAuthSuccess: onAuthSuccess);
      setLoading(false);
    } catch (error) {
      if (context.mounted) {
        loginAuthRepository.showError(context, error);
      }
      setLoading(false);
    }
  }

  Future<void> finishAuth(
    BuildContext context,
    User? user, {
    LoginCustomSuccessCallback? onAuthSuccess,
  }) async {
    if (onAuthSuccess != null) {
      // ignore: use_build_context_synchronously
      await onAuthSuccess(context, user);
      return;
    }

    openSnackbar(
      context,
      text: "Cuenta creada correctamente",
      isError: false,
      isDone: true,
    );
  }

  void startVerificationTimer(
    BuildContext context, {
    LoginCustomSuccessCallback? onAuthSuccess,
  }) {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      final User? user = FirebaseAuth.instance.currentUser;
      final bool isVerified = await loginAuthRepository
          .reloadAndCheckEmailVerified();
      if (!context.mounted) {
        return;
      }

      if (user != null && isVerified) {
        timer.cancel();
        setVerifying(false);

        // ✅ Cerramos el bottom sheet si sigue abierto.
        if (Navigator.canPop(context)) {
          goBack(context);
        }

        await finishAuth(context, user, onAuthSuccess: onAuthSuccess);
      }
    });
  }
}
