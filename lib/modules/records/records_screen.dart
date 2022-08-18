import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/layout/cubit/cubit.dart';
import 'package:flutter_clock_quiz/layout/cubit/state.dart';
import 'package:flutter_clock_quiz/shared/components/components.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlutterClockCubit, FlutterClockStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FlutterClockCubit cubit = FlutterClockCubit.get(context);
        var records = cubit.newAlarms;
        return Scaffold(
          body: SafeArea(child: RecordsBuilder(records: records,context: context)),
        );
      },
    );
  }
}
