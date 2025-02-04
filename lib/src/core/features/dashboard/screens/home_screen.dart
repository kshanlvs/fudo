import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late ConfettiController _centerController;

  @override
  void initState() {
    super.initState();

    // Initialize confetti controller
    _centerController = ConfettiController(
      
      duration: const Duration(seconds: 5));
    _centerController.play();

    // Show a welcome offer dialog when the page loads
    Future.delayed(Duration.zero, () {
      _showWelcomeOfferDialog();
    });
  }

  @override
  void dispose() {
    // Dispose the controller
    _centerController.dispose();
    super.dispose();
  }

   Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  // Function to show the welcome offer dialog
  void _showWelcomeOfferDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome to Fudo!'),
          content: const Text('We have an exciting welcome offer just for you!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: 
              ConfettiWidget(

            blastDirectionality: BlastDirectionality
                  .explosive,  
                confettiController: _centerController,
                blastDirection: pi / 2,
                maxBlastForce: 20,
                minBlastForce: 1,
                emissionFrequency: 0.03,
                numberOfParticles: 10,
                gravity: 0,
                 createParticlePath: drawStar
             
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                onPressed: () {
                  _centerController.play();
                },
                child: const Text(
                  'Welcome to Fudo',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
