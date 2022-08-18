abstract class FlutterClockRegisterStates {}

class FlutterClockRegisterInitialState extends FlutterClockRegisterStates {}

class FlutterClockRegisterLoadingState extends FlutterClockRegisterStates {}

class FlutterClockRegisterSuccessState extends FlutterClockRegisterStates {}

class FlutterClockRegisterErrorState extends FlutterClockRegisterStates {
  final String error;

  FlutterClockRegisterErrorState(this.error);
}

class FlutterClockCreateUserSuccessState extends FlutterClockRegisterStates {}

class FlutterClockCreateUserErrorState extends FlutterClockRegisterStates {
  final String error;

  FlutterClockCreateUserErrorState(this.error);
}

class FlutterClockRegisterChangePasswordVisibiltyState extends FlutterClockRegisterStates {}
