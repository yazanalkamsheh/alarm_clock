// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace, unnecessary_cast

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/layout/cubit/cubit.dart';
import 'package:flutter_clock_quiz/layout/cubit/state.dart';
import 'package:flutter_clock_quiz/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlutterClockCubit, FlutterClockStates>(
        listener: (context, state) {},
        builder: (context, state) {
          FlutterClockCubit cubit = FlutterClockCubit.get(context);

          var nameController = TextEditingController();
          var emailController = TextEditingController();
          var phoneController = TextEditingController();
          var userModel = cubit.userModel!;
          var profileImage = cubit.profileImage;
          var coverImage = cubit.coverImage;

          nameController.text = userModel.name!;
          emailController.text = userModel.email!;
          phoneController.text = userModel.phone!;

          PreferredSizeWidget appBar() {
            return defaultAppBar(
              context: context,
              title: 'Profile',
              action: [
                defaultTextButton(
                  function: () {
                    cubit.updateUser(
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                    );
                    if(cubit.coverImage != null){
                      cubit.uploadCoverImage(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      );
                    }
                    if(cubit.profileImage != null)
                    {
                      cubit.uploadProfileImage(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      );
                    }


                  },
                  text: 'UPDATE',
                ),
              ],
            );
          }

          Widget buildUserName() {
            return defaultFormField(
              controller: nameController,
              type: TextInputType.name,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'name must be not empty';
                }
              },
              label: 'Name',
              prefix: Icons.person,
            );
          }

          Widget buildEmail() {
            return defaultFormField(
              controller: emailController,
              type: TextInputType.emailAddress,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'email must be not empty';
                }
              },
              label: 'Email Address',
              prefix: Icons.email,
            );
          }

          Widget buildPhone() {
            return defaultFormField(
              controller: phoneController,
              type: TextInputType.phone,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'phone must be not empty';
                }
              },
              label: 'Phone Number',
              prefix: Icons.phone,
            );
          }

          Widget buildLogOutButton() {
            return defaultButton(
              function: () {
                cubit.signOut(context);
              },
              text: 'Log out',
            );
          }

          return ConditionalBuilder(
            condition: cubit.userModel != null,
            builder: (context) => Scaffold(
              appBar: appBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (state is FlutterClockUserUpdateLoadingState)
                        LinearProgressIndicator(),
                      if (state is FlutterClockUserUpdateLoadingState)
                        SizedBox(
                          height: 10.0,
                        ),
                      Container(
                        height: 190.0,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          4.0,
                                        ),
                                        topRight: Radius.circular(
                                          4.0,
                                        ),
                                      ),
                                      image: DecorationImage(
                                        image: coverImage == null
                                            ? NetworkImage(
                                                '${userModel.cover}',
                                              )
                                            : FileImage(coverImage)
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                      ),
                                    ),
                                    onPressed: () {
                                      cubit.getCoverImage();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 64.0,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    backgroundImage: profileImage == null
                                        ? NetworkImage(
                                            '${userModel.image}',
                                          )
                                        : FileImage(profileImage)
                                            as ImageProvider,
                                    radius: 60.0,
                                  ),
                                ),
                                IconButton(
                                  icon: CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                    ),
                                  ),
                                  onPressed: () {
                                    cubit.getProfileImage();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      buildUserName(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildEmail(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildPhone(),
                      SizedBox(
                        height: 20.0,
                      ),
                      buildLogOutButton(),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
