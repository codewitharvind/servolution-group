import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Styles {
  static const spinLoader = SpinKitThreeBounce(
    color: Color(0xfffcb913),
    size: 30.0,
  );

  static Text headingText = Text(
    "M - AUDIT",
    style: GoogleFonts.poppins(fontSize: 30.0, color: const Color(0xff3c4250)),
  );

  static TextStyle googleFontGrey =
      GoogleFonts.poppins(fontSize: 15.0, color: const Color(0xff939298));

  static TextStyle googleFontBlack =
      GoogleFonts.poppins(fontSize: 15.0, color: Colors.black);

  static const appScreenLineDivider = Padding(
    padding: EdgeInsets.fromLTRB(10.0, 00.0, 10.0, 0.0),
    child: Divider(
      color: Colors.black,
      thickness: 1.0,
    ),
  );

  static const appSmallText = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.normal,
      fontSize: 10.0,
      color: Colors.black);

  static const appSmallNormalText = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
      color: Colors.black);

  static const appSmallBoldText = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
      color: Colors.black);

  static const appNormalChatText = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
      color: Colors.black);

  static const appHorizontalDivider = Padding(
    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
    child: Divider(
      color: Color(0xFFcccccc),
      thickness: 0.7,
    ),
  );
}
