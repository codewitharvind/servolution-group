import "package:flutter/material.dart";

class OtherPage extends StatelessWidget{

  final String pageTextChanged;
  // ignore: use_key_in_widget_constructors
  const OtherPage(this.pageTextChanged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTextChanged),
        backgroundColor: Colors.black,),
      body: Center(
        child: Text(pageTextChanged),
      ),
    );
  }
}