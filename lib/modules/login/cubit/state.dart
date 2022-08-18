abstract class FlutterClockLoginStates {}

class FlutterClockLoginInitialState extends FlutterClockLoginStates {}

class FlutterClockLoginLoadingState extends FlutterClockLoginStates {}

class FlutterClockLoginSuccessState extends FlutterClockLoginStates
{
  final String uId;
  FlutterClockLoginSuccessState(this.uId);
}

class FlutterClockLoginErrorState extends FlutterClockLoginStates {
  final String error;

  FlutterClockLoginErrorState(this.error);
}

class FlutterClockChangePasswordVisibiltyState extends FlutterClockLoginStates {}
