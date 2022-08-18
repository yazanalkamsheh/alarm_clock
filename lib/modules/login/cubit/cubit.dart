// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/modules/login/cubit/state.dart';


class FlutterClockLoginCubit extends Cubit<FlutterClockLoginStates>{
  FlutterClockLoginCubit() : super(FlutterClockLoginInitialState());

  static FlutterClockLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(FlutterClockLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password,).then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      emit(FlutterClockLoginSuccessState(value.user!.uid));
    }).catchError((error)
    {
      emit(FlutterClockLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(FlutterClockChangePasswordVisibiltyState());
  }
}