import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/chatScreen.dart';
import 'package:photo_view/photo_view.dart';

class ChatImage extends StatefulWidget {
  final String text, id;
  const ChatImage({Key? key, required this.text, required this.id})
      : super(key: key);

  @override
  _ChatImageState createState() => _ChatImageState();
}

class _ChatImageState extends State<ChatImage> {
  @override
  void initState() {
    super.initState();
    print(widget.text);
    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        text: widget.id,
                      ))),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title:  Text(
          "CHAT IMAGE",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: Image.network(
        widget.text,
        fit: BoxFit.fill,
        alignment: Alignment.center,
      ),
    );
  }
}
