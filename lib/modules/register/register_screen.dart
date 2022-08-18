// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/modules/login/login_screen.dart';
import 'package:flutter_clock_quiz/modules/register/cubit/cubit.dart';
import 'package:flutter_clock_quiz/modules/register/cubit/state.dart';
import 'package:flutter_clock_quiz/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => FlutterClockRegisterCubit(),
      child: BlocConsumer<FlutterClockRegisterCubit,FlutterClockRegisterStates>(
        listener: (context, state) {
          if(state is FlutterClockCreateUserSuccessState) {
            navigateAndFinish(
              context,
              LoginScreen(),
            );
          }
        },
        builder: (context, state) {

          FlutterClockRegisterCubit cubit = FlutterClockRegisterCubit.get(context);

          Widget buildUserName() {
            return defaultFormField(
              controller: nameController,
              type: TextInputType.name,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
              },
              label: 'User Name',
              prefix: Icons.person,
            );
          }
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
              isPassword: cubit.isPassword,
              label: 'Password',
              prefix: Icons.lock_outline,
              suffix: cubit.suffix,
              suffixPressed: () {
                cubit.changePasswordVisibility();
              },
            );
          }
          Widget buildPhone() {
            return defaultFormField(
              controller: phoneController,
              type: TextInputType.phone,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                }
              },
              label: 'Phone',
              prefix: Icons.phone,
            );
          }
          Widget buildButton() {
            return ConditionalBuilder(
              condition: state is! FlutterClockRegisterLoadingState,
              builder: (context) => defaultButton(
                function: () {
                  if (formKey.currentState!.validate()) {
                    cubit.userRegister(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      phone: phoneController.text,
                    );
                  }
                },
                text: 'register',
              ),
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: defaultAppBar(context: context,titleSpacing: 5.0,leading: Icons.arrow_back),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 20.0,left: 20.0,right: 20.0,),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children:  [
                      Image(
                        image: AssetImage(
                          'assets/register.png',
                        ),
                      ),
                      buildUserName(),
                      SizedBox(
                        height: 12.0,
                      ),
                      buildEmail(),
                      SizedBox(
                        height: 12.0,
                      ),
                      buildPassword(),
                      SizedBox(
                        height: 12.0,
                      ),
                      buildPhone(),
                      SizedBox(
                        height: 20.0,
                      ),
                      buildButton(),
                    ],
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
