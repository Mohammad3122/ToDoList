import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

alertDialogWarning(BuildContext context, String title, String desc) {
  return AwesomeDialog(
    dialogBackgroundColor: backGroundColor,
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.scale,
    headerAnimationLoop: false,
    title: title,
    desc: desc,
    btnOkOnPress: () {},
    btnOkColor: Colors.amber[600],
    btnOkText: 'برگشت',
    // buttonsTextStyle: getBodyBoldWhiteStyle(context),
  ).show();
}

alertDialogError(
  BuildContext context,
  String title,
  String desc,
) {
  return AwesomeDialog(
    dialogBackgroundColor: backGroundColor,
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.bottomSlide,
    headerAnimationLoop: false,
    title: title,
    titleTextStyle: TextStyle(
        fontFamily: 'adobe_arabic', color: Colors.black, fontSize: 35),
    desc: desc,
    descTextStyle:
        TextStyle(fontFamily: 'nasim', color: Colors.black, fontSize: 20),
    btnOkOnPress: () {},
    btnOkColor: Colors.amber[900],
    btnOkText: 'برگشت',
    // buttonsTextStyle: getBodyBoldWhiteStyle(context),
  ).show();
}
