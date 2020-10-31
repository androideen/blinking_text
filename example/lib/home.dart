import 'package:flutter/material.dart';
import 'package:blinking_text/blinking_text.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: BlinkText(
              'Blink Animation',
              style: TextStyle(fontSize: 24),
              beginColor: Colors.white,
              endColor: Colors.red,
              times: 100,
              duration: Duration(seconds: 1),
            ),
          ),
        ],
      ),
    );
  }
}
