// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/models/flutter_clock/flutter_clock_user_model.dart';
import 'package:flutter_clock_quiz/modules/register/cubit/state.dart';


class FlutterClockRegisterCubit extends Cubit<FlutterClockRegisterStates>{
  FlutterClockRegisterCubit() : super(FlutterClockRegisterInitialState());

  static FlutterClockRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(FlutterClockRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      print(error.toString());
      emit(FlutterClockRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    FlutterClockUserModel model = FlutterClockUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: 'https://img.freepik.com/free-photo/man-formal-clothes-talking-phone_23-2149038073.jpg?w=360',
      cover: 'https://img.freepik.com/free-photo/man-formal-clothes-talking-phone_23-2149038073.jpg?w=360',
      isEmailVerfied: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(FlutterClockCreateUserSuccessState());
    }).catchError((error) {
      emit(FlutterClockCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(FlutterClockRegisterChangePasswordVisibiltyState());
  }
}