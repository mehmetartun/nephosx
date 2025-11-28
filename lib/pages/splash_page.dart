import 'dart:async';

import 'package:flutter/material.dart';

import '../model/app_instruction.dart';
import '../widgets/instructions_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer oneTimer;
  @override
  void initState() {
    // TODO: implement initState
    oneTimer = Timer(const Duration(seconds: 3000000), () {
      Navigator.of(context).pop();
    });
    super.initState();
  }

  @override
  void dispose() {
    oneTimer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InstructionsWidget(
      appInstructions: [
        AppInstruction(
          title: "Welcome to Drink Diary",
          description:
              "This is app is designed to help you moderate your drinking habits. "
              "By simply recording what you drank you will keep track of how many calories "
              "you took via drinks as well as how many units of alcohol you consumed.",
          imagePath: "assets/images/DrinkingImage.jpg",
        ),
        AppInstruction(
          title: "How does it work?",
          description:
              "Just go to the Diary tab and enter your drink"
              " category (like wine, beer, etc), drink type (like white wine, lager beer, etc)"
              " and amount. You don't need to enter anything with the keyboard, just a few button clicks"
              " will do the job. \n\nWe have calculated the alcohol units"
              " and calories for many drinks so that all you"
              " need to do is click a button!",
          imagePath: "assets/images/BarImage.jpg",
        ),
        AppInstruction(
          title: "Check your stats",
          description:
              "The Stats page shows a list of your consumption per day"
              " with a list of consumption for that day."
              " Clicking the monthly summary will show you a graph with "
              "the days you had a drink and the units and calories you consumed.",
          imagePath: "assets/images/WhiskeyImage.jpg",
        ),
        AppInstruction(
          title: "Let's Go",
          description:
              "Give it a go. Start by filling up"
              " the information for the last few days and get your stats",
          imagePath: "assets/images/AppleCiderImage.jpg",
        ),
      ],

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       CircularProgressIndicator(),
      //       SizedBox(height: 20),
      //       Text('Loading...'),
      //     ],
      //   ),
      // ),
    );
  }
}
