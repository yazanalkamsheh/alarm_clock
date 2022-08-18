// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/layout/flutter_clock.dart';
import 'package:flutter_clock_quiz/modules/login/cubit/cubit.dart';
import 'package:flutter_clock_quiz/modules/login/cubit/state.dart';
import 'package:flutter_clock_quiz/shared/components/components.dart';
import 'package:flutter_clock_quiz/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => FlutterClockLoginCubit(),
      child: BlocConsumer<FlutterClockLoginCubit, FlutterClockLoginStates>(
        listener: (context,state){
          if(state is FlutterClockLoginErrorState)
          {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if(state is FlutterClockLoginSuccessState)
          {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              navigateAndFinish(
                context,
                FlutterClockLayout(),
              );
            });
          }
        },
        builder: (context,state){

          FlutterClockLoginCubit cubit =  FlutterClockLoginCubit.get(context);

          Widget buildEmail() {
            return defaultFormField(
              controller: emailController,
              type: TextInputType.emailAddress,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email address';
                }
              },
              label: 'Email Address',
              prefix: Icons.email_outlined,
            );
          }
          Widget buildPassword() {
            return defaultFormField(
              controller: passwordController,
              type: TextInputType.visiblePassword,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Password is too short';
                }
              },
              onSubmit: (value) {
                if(formKey.currentState!.validate())
                {
                  cubit.userLogin(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                }
              },
              isPassword: cubit.isPassword,
              label: 'Password',
              prefix: Icons.lock_outline,
              suffix: cubit.suffix,
              suffixPressed: () {
                cubit.changePasswordVisibility();
              },
            );
          }
          Widget buildButton() {
            return ConditionalBuilder(
              condition: state is! FlutterClockLoginLoadingState,
              builder: (context) => defaultButton(
                function: () {
                  if (formKey.currentState!.validate()) {
                    cubit.userLogin(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  }
                },
                text: 'login',
              ),
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: defaultAppBar(context: context,titleSpacing: 5.0,leading: Icons.arrow_back,),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/welcome.png'),
                        ),
                        buildEmail(),
                        SizedBox(
                          height: 12.0,
                        ),
                        buildPassword(),
                        SizedBox(
                          height: 20.0,
                        ),
                        buildButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
