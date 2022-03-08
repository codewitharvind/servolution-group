import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/HSK_House_Keeping.dart';

class HSK_House_Keeping_image extends StatefulWidget {
  const HSK_House_Keeping_image({Key? key}) : super(key: key);

  @override
  State<HSK_House_Keeping_image> createState() =>
      _HSK_House_Keeping_imageState();
}

class _HSK_House_Keeping_imageState extends State<HSK_House_Keeping_image> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HSK_House_keeping())),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "HOUSE KEEPING IMAGE",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),);
  }
}
