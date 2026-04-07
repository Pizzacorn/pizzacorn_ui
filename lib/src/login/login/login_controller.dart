import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class LoginCustomState {
  final bool loading;
  final bool isEmailVerifying;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;

  LoginCustomState({
    this.loading = false,
    this.isEmailVerifying = false,
    required this.controllerEmail,
    required this.controllerPassword,
  });

  LoginCustomState copyWith({bool? loading, bool? isEmailVerifying}) {
    return LoginCustomState(
      loading: loading ?? this.loading,
      isEmailVerifying: isEmailVerifying ?? this.isEmailVerifying,
      controllerEmail: controllerEmail,
      controllerPassword: controllerPassword,
    );
  }
}

final loginCustomControllerProvider =
    StateNotifierProvider.autoDispose<LoginCustomController, LoginCustomState>((
      ref,
    ) {
      return LoginCustomController();
    });

class LoginCustomController extends StateNotifier<LoginCustomState> {
  Timer? timer;
  final LoginCustomAuthRepository loginAuthRepository =
      LoginCustomAuthRepository();

  LoginCustomController()
    : super(
        LoginCustomState(
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

  void setLoading(bool value) => state = state.copyWith(loading: value);

  void setVerifying(bool value) {
    state = state.copyWith(isEmailVerifying: value);
  }

  Future<void> login(
    BuildContext context, {
    bool google = false,
    bool password = false,
    bool apple = false,
    LoginCustomSuccessCallback? onAuthSuccess,
  }) async {
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
          setLoading(false);
          return;
        }

        userCredential = await loginAuthRepository.loginWithEmail(
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

        // 📩 Enviamos el correo de verificacion por si no le llego.
        await loginAuthRepository.sendVerificationEmail();
        if (!context.mounted) {
          return;
        }

        // 🍕 Mostramos el aviso mientras esperamos la verificacion.
        openBottomSheet(context, VerifyEmailCustomPage(), height: 300);

        // ⏱️ Comprobamos cada pocos segundos si ya esta verificado.
        startVerificationTimer(context, onAuthSuccess: onAuthSuccess);
        return;
      }

      if (!context.mounted) {
        return;
      }
      await finishAuth(
        context,
        userCredential.user,
        onAuthSuccess: onAuthSuccess,
      );
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
      text: "Sesion iniciada correctamente",
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
