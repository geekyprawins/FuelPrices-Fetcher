// @dart=2.9

import 'package:flutter/material.dart';
import 'package:fuel_prices_india/fuel_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fuel Prices India',
        theme: ThemeData.dark(),
        home: AnimatedSplashScreen(
          splash: Hero(tag: 'icon', child: Image.asset('images/icon-fuel.png')),
          nextScreen: FuelPrice(),
          splashIconSize: 100.0,
          splashTransition: SplashTransition.scaleTransition,
        ));
  }
}
