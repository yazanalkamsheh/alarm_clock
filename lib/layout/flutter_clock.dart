// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/layout/cubit/cubit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'cubit/state.dart';

class FlutterClockLayout extends StatelessWidget {
  const FlutterClockLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlutterClockCubit()..createDatabase()..getUserData(),
      child: BlocConsumer<FlutterClockCubit,FlutterClockStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          FlutterClockCubit cubit = FlutterClockCubit.get(context);
          return Scaffold(
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: Container(
              color: Color(0xFF2D2F41),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                child: GNav(
                  backgroundColor: Color(0xFF2D2F41),
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: Color(0xFF555769),
                  gap: 8,
                  selectedIndex: cubit.currentIndex,
                  onTabChange: (index){
                    cubit.changeBottomNavBar(index);
                  },
                  padding: EdgeInsets.all(16),
                  tabs: cubit.bottomItems,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
