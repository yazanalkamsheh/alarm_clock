// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/layout/cubit/state.dart';
import 'package:flutter_clock_quiz/models/flutter_clock/flutter_clock_user_model.dart';
import 'package:flutter_clock_quiz/modules/alarm/alarm_screen.dart';
import 'package:flutter_clock_quiz/modules/records/records_screen.dart';
import 'package:flutter_clock_quiz/modules/to_profile/to_profile_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/profile/profile_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constant.dart';
import '../../shared/network/local/cache_helper.dart';

class FlutterClockCubit extends Cubit<FlutterClockStates> {
  FlutterClockCubit() : super(FlutterClockInitialState());

  static FlutterClockCubit get(context) => BlocProvider.of(context);

  final nll = null;

  int currentIndex = 0;
  bool isBottomSheetShown = false;
  Database? database;

  FlutterClockUserModel? userModel;

  void getUserData() {
     emit(FlutterClockUserModelGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = FlutterClockUserModel.fromJson(value.data()!);
      emit(FlutterClockUserModelGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      print("hello yazan");
      emit(FlutterClockUserModelGetUserErrorState(error.toString()));
    });
  }

  List<GButton> bottomItems = [
    GButton(
      icon: Icons.home,
      text: 'Alarm',
    ),
    GButton(
      icon: Icons.search,
      text: 'Records',
    ),
    GButton(
      icon: Icons.settings,
      text: 'My Profile',
    ),
  ];

  List<Widget> screens = [
    AlarmScreen(),
    RecordsScreen(),
    ProfileScreen(),
  ];

  List<String> titles = [
    'Alarm',
    'Records',
    'Profile',
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 2) {
      getUserData();
    }
    emit(FlutterClockBottomNavState());
  }

  List<Map> newAlarms = [];

  void createDatabase() {
    openDatabase(
      'alarm.db',
      version: 1,
      onCreate: (database, version) {

        print('database created');
        database
            .execute(
            'CREATE TABLE alarms ( id INTEGER PRIMARY KEY, time TEXT, date TEXT, hoursOfSleep INTEGER,minuteOfSleep INTEGER,nameDayOfWeek TEXT)')
            .then((value) {
          print('table created');
        }).catchError((onError) {
          print('Error When Creating Table ${onError.toString()}');
        });
      },
      onOpen: (database) {
        //getUserData();
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      //getUserData();
      database = value;

      emit(FlutterClockCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String time,
    required String date,
    required int hoursOfSleep,
    required int minuteOfSleep,
    required String nameDayOfWeek,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO alarms(time,date,hoursOfSleep,minuteOfSleep,nameDayOfWeek) VALUES("$time","$date","$hoursOfSleep","$minuteOfSleep","$nameDayOfWeek")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(FlutterClockInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((onError) {
        print('Error When Inserting New Alarm ${onError.toString()}');
      });
      return nll;
    });
  }


  void getDataFromDatabase(database) {
    newAlarms = [];
    emit(FlutterClockGetDatabaseLoadState());
    database.rawQuery('SELECT * FROM alarms').then((value) {
      value.forEach((element) {
        newAlarms.add(element);
      });

      emit(FlutterClockGetDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database?.rawDelete(
      'DELETE FROM alarms WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(FlutterClockDeleteDatabaseState());
      print('Success Delete');
    });
  }

  void signOut(context) {
    CacheHelper.removeData(
      key: 'uId',
    ).then((value) {
      if (value) {
        navigateAndFinish(
          context,
          ToProfileScreen(),
        );
        //uId = '';
      }
    });
  }

  void updateUser({
    String? name,
    String? email,
    String? phone,
    String? image,
    String? cover,
  }) {
    FlutterClockUserModel model = FlutterClockUserModel(
      name: name,
      phone: phone,
      email: email,
      uId:  userModel!.uId,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      isEmailVerfied: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(FlutterClockUserUpdateErrorState());
    });
  }

  File? profileImage;
  ImagePicker picker = ImagePicker();

  Future<void> getProfileImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImage = File(image.path);
      emit(FlutterClockProfileImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(FlutterClockProfileImagePickerErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      coverImage = File(image.path);
      emit(FlutterClockCoverImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(FlutterClockCoverImagePickerErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String email,
}) {
    emit(FlutterClockUserUpdateLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(
          name: name,
          phone: phone,
          email: email,
          image: value,
        );
      }).catchError((error) {
        print(error.toString());
        emit(FlutterClockUploadProfileImageErrorState());
      });
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String email,
}) {
    emit(FlutterClockUserUpdateLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(
          email: email,
          name: name,
          phone: phone,
          cover: value,
        );
      }).catchError((error) {
        emit(FlutterClockUploadCoverImageErrorState());
      });
    });
  }

}