import 'package:LikLok/models/Intro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late Intro? intro ;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
         width: MediaQuery.sizeOf(context).width,
         height: MediaQuery.sizeOf(context).height,

      ),
    );
  }
}
