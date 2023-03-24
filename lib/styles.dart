import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double fontNormal = 18;
double fontHeading = 24;
double fontSmall = 14;

double defaultPadding = 24;

TextStyle textTitle = GoogleFonts.lato(
    textStyle: TextStyle(
        color: Colors.white,
        fontSize: fontNormal,
        fontWeight: FontWeight.bold));

TextStyle textNormal = GoogleFonts.lato(
    textStyle: TextStyle(
  color: Colors.white,
  fontSize: fontNormal,
));

TextStyle customInputHintStyle = GoogleFonts.lato(
    textStyle: TextStyle(
  color: Colors.grey.shade600,
  fontSize: 18,
));

TextStyle customInputStyle = GoogleFonts.lato(
    textStyle: TextStyle(
  color: Colors.grey.shade400,
  fontSize: 18,
));

const customButtonTexColor = Colors.white;
const customPressedButtonTextColor = Colors.white;

const customButtonBackgroundColor = Colors.black;

const customButtonPressedBackgroundColor = Color.fromARGB(0, 11, 11, 11);

const customDialogBackgroundColor = Colors.black;

TextStyle customDialogTitleStyle = textTitle;
