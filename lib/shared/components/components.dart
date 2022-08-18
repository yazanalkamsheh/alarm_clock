// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, constant_identifier_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_quiz/layout/cubit/cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  IconData? leading,
  String? title ='',
  double? titleSpacing,
  List<Widget>? action,
}) =>
    AppBar(
      leading: IconButton(
        icon: Icon(
          leading,
          color: Color(0xFF2D2F41),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('${title!}'),
      titleSpacing: titleSpacing,
      backgroundColor: Colors.white,
      elevation: 0.0,

      actions: action,
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType? type,
  bool isPassword = false,
  bool isClickable = true,
  Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  void Function()? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      onTap: onTap,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        fillColor: Color(0xFF2D2F41),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
      ),
    );


Widget defaultButton({
  double width = double.infinity,
  Color background = const Color(0xFF2D2F41),
  bool isUpperCase = true,
  double radius = 20.0,
  required VoidCallback? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 45.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required Function() function,
  required String text,
  FontWeight? fontWeight,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontWeight: fontWeight,
        ),
      ),
    );

/////////////////////////////////////////////////////////////////////////////

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color? chooseToastColor(ToastStates state) {
  Color? color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}


////////////////////////////////////////////////

Widget buildAlarmIem(Map model, context) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
  child: Dismissible(
    key: Key(
      model['id'].toString(),
    ),
    background: Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white),
            Text('Move to trash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
    confirmDismiss: (DismissDirection direction) async {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Confirmation"),
            content:
            const Text("Are you sure you want to delete this item?"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    },
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.yellow],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2D2F41).withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.label,
                color: Colors.white,
                size: 24.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                model['time'],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                model['date'],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                ),
              ),
              Switch(
                value: false,
                onChanged: (value) {
                  if(value == true)
                  {

                  }
                },
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      FlutterClockCubit.get(context).deleteData(
        id: model['id'],
      );
    },
  ),
);

Widget buildRecordItem(Map model, context) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
  child: Dismissible(
    key: Key(
      model['id'].toString(),
    ),
    background: Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white),
            Text('Move to trash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
    confirmDismiss: (DismissDirection direction) async {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Confirmation"),
            content:
            const Text("Are you sure you want to delete this item?"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    },
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.yellow],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2D2F41).withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.label,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    model['hoursOfSleep'].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    model['minuteOfSleep'].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Hours',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    model['date'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    model['nameDayOfWeek'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      FlutterClockCubit.get(context).deleteData(
        id: model['id'],
      );
    },
  ),
);


Widget alarmsBuilder({
  alarms,
  context,
}) =>
    ConditionalBuilder(
      condition: alarms.isNotEmpty,
      builder: (context) => Expanded(
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => buildAlarmIem(alarms[index], context),
          separatorBuilder: (context, index) => Container(),
          itemCount: alarms.length,
        ),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm,
              color: Colors.grey,
              size: 100.0,
            ),
            SizedBox(
              height: 14.0,
            ),
            Text(
              'No Alarms Yet, Please Add Some Alarms',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );

Widget RecordsBuilder({
  records,
  context,
}) =>
    ConditionalBuilder(
      condition: records.isNotEmpty,
      builder: (context) => Expanded(
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {

            return buildRecordItem(records[index], context,);
          },
          separatorBuilder: (context, index) => Container(),
          itemCount: records.length,
        ),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm,
              color: Colors.grey,
              size: 100.0,
            ),
            SizedBox(
              height: 14.0,
            ),
            Text(
              'No Alarms Yet, Please Add Some Alarms',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
