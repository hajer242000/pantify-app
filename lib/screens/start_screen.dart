import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Timer timer;
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushNamed(context, '/signIn');
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.network(
            'https://lottie.host/c7947b1c-9e6a-460f-b801-9b798558c868/FIsq2URkWg.json',
          ),
          Text('Pantify', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
