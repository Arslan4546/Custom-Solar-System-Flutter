import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GlobeScreen(),
    );
  }
}

class GlobeScreen extends StatefulWidget {
  const GlobeScreen({super.key});

  @override
  _GlobeScreenState createState() => _GlobeScreenState();
}

class _GlobeScreenState extends State<GlobeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool showPlanets = false; // To control when the planets appear
  double angle = 0.0; // For rotation tracking

  // Different sizes for 8 planets
  List<double> planetSizes = [30.0, 35.0, 15.0, 25.0, 20.0, 18.0, 22.0, 28.0];

  // Radii for 8 planets with some space between them
  List<double> orbitRadii = [
    120.0,
    140.0,
    160.0,
    180.0,
    200.0,
    220.0,
    240.0,
    260.0
  ];

  // Track if planets completed rounds
  List<bool> planetCompletedRounds = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  // Different starting angles for each planet
  List<double> initialAngles = [0.0, 23, 10, 70, 120, 150, 170, 200];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Speed of planets' movement
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(
              begin: 0.0, end: 140.0), // Reduced globe size from 200.0 to 150.0
          duration: const Duration(seconds: 3), // Time for the globe to grow
          curve: Curves.easeOut, // Smooth effect
          onEnd: () {
            setState(() {
              showPlanets =
                  true; // Show planets after the globe finishes growing
              _controller.repeat(); // Start planet animation
            });
          },
          builder: (context, size, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Growing Globe (Sun)
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow, // Sun's color (sunny yellow)
                  ),
                ),
                // Circular Lines (Orbits) around the globe
                if (showPlanets)
                  ...orbitRadii.map((radius) => Positioned(
                        child: CustomPaint(
                          size: Size(size, size),
                          painter: OrbitPainter(radius: radius),
                        ),
                      )),
                // Planets rotating around the globe
                if (showPlanets)
                  ...List.generate(planetSizes.length, (index) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        double angle = _controller.value * 2 * pi +
                            initialAngles[
                                index]; // Full rotation + initial offset
                        double radius = orbitRadii[
                            index]; // Distance of the planet from globe center
                        double planetX =
                            radius * cos(angle); // X position of the planet
                        double planetY =
                            radius * sin(angle); // Y position of the planet

                        // Stop animation after a complete round for each planet
                        if (_controller.value >= 1.0 &&
                            !planetCompletedRounds[index]) {
                          planetCompletedRounds[index] = true;
                          _controller.stop();
                        }

                        return Transform.translate(
                          offset: Offset(planetX, planetY), // Move planet
                          child: Container(
                            width: planetSizes[index],
                            height: planetSizes[index],
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getPlanetColor(
                                  index), // Color for each planet
                            ),
                          ),
                        );
                      },
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }

  // Get a distinct color for each planet
  Color _getPlanetColor(int index) {
    switch (index) {
      case 0:
        return Colors.red; // Example: Red planet
      case 1:
        return Colors.green; // Example: Green planet
      case 2:
        return Colors.orange; // Example: Orange planet
      case 3:
        return Colors.blue; // Example: Blue planet
      case 4:
        return Colors.purple; // Example: Purple planet
      case 5:
        return Colors.cyan; // Example: Cyan planet
      case 6:
        return Colors.indigo; // Example: Indigo planet
      case 7:
        return Colors.brown; // Example: Brown planet
      default:
        return Colors.white; // Default color for any new planets
    }
  }
}

// Custom painter to draw the orbits (lines) around the globe
class OrbitPainter extends CustomPainter {
  final double radius;
  OrbitPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the orbit (circle)
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
