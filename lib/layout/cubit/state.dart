// ignore_for_file: camel_case_types

abstract class FlutterClockStates {}

class FlutterClockInitialState extends FlutterClockStates {}

class FlutterClockBottomNavState extends FlutterClockStates {}

class FlutterClockCreateDatabaseState extends FlutterClockStates {}

class FlutterClockInsertDatabaseState extends FlutterClockStates {}

class FlutterClockGetDatabaseLoadState extends FlutterClockStates {}

class  FlutterClockGetDatabaseState extends FlutterClockStates {}

class  FlutterClockDeleteDatabaseState extends FlutterClockStates {}

class FlutterClockUserModelGetUserLoadingState extends FlutterClockStates{}

class FlutterClockUserModelGetUserSuccessState extends FlutterClockStates {}

class FlutterClockUserModelGetUserErrorState extends FlutterClockStates
{
  final String error;
  FlutterClockUserModelGetUserErrorState(this.error);
}

class FlutterClockUserUpdateLoadingState extends FlutterClockStates {}

class FlutterClockUserUpdateErrorState extends FlutterClockStates {}

// handle from gallery Profile Image

class FlutterClockProfileImagePickerSuccessState extends FlutterClockStates {}

class FlutterClockProfileImagePickerErrorState extends FlutterClockStates {}

// handle from gallery Cover Image

class FlutterClockCoverImagePickerSuccessState extends FlutterClockStates {}

class FlutterClockCoverImagePickerErrorState extends FlutterClockStates {}

// upload profile image

class FlutterClockUploadProfileImageErrorState extends FlutterClockStates {}

// upload cover image

class FlutterClockUploadCoverImageErrorState extends FlutterClockStates {}




