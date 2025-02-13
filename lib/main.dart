// names : Sri Charan Reddy Tokala and Sri Krishna Kolii
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(HeartbeatApp());
}

class HeartbeatApp extends StatefulWidget {
  @override
  _HeartbeatAppState createState() => _HeartbeatAppState();
}

class _HeartbeatAppState extends State<HeartbeatApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _countdown = 10;
  bool _showValentineMessage = false;
  Timer? _timer;
  List<Offset> balloons = [];
  final String heartImageAsset = "assets/heart.jpg";

  List<String> loveQuotes = [
    "Love is not finding someone to live with, it’s finding someone you can’t live without.",
    "You are my today and all of my tomorrows.",
    "Love is like the wind, you can’t see it but you can feel it.",
    "Where there is love, there is life.",
    "In dreams and in love, there are no impossibilities.",
    "The best thing to hold onto in life is each other."
  ];
  String currentQuote = "";
  Color valentineTextColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
    generateBalloons();
  }

  void startCountdown() {
    setState(() {
      _countdown = 10;
      _showValentineMessage = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        setState(() {
          _showValentineMessage = true;
        });

        // Change Valentine's text color every second
        Timer.periodic(Duration(seconds: 1), (t) {
          if (!_showValentineMessage) {
            t.cancel();
            return;
          }
          setState(() {
            valentineTextColor = _getRandomColor();
          });
        });
      } else {
        setState(() {
          _countdown--;
          currentQuote = loveQuotes[Random().nextInt(loveQuotes.length)];
        });
      }
    });
  }

  void generateBalloons() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        double xPosition;
        bool fromLeft = Random().nextBool(); // 50% chance left or right

        if (fromLeft) {
          xPosition = Random().nextDouble() * 100; // Left side (0 to 100px)
        } else {
          xPosition = 200 + Random().nextDouble() * 100; // Right side (200 to 300px)
        }

        balloons.add(Offset(xPosition, 500));
      });

      if (balloons.length > 30) {
        balloons.removeAt(0);
      }
    });
  }

  Color _getRandomColor() {
    List<Color> colors = [Colors.red, Colors.pink, Colors.white];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removed debug banner
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[200]!, Colors.purple[300]!], // Modern gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Floating balloons appear on both left & right sides
              for (var balloon in balloons)
                Positioned(
                  left: balloon.dx,
                  bottom: balloon.dy,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: balloon.dy, end: -50),
                    duration: Duration(seconds: 5),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value),
                        child: Icon(Icons.favorite, color: Colors.redAccent, size: 30),
                      );
                    },
                  ),
                ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_showValentineMessage) ...[
                      Text(
                        "Countdown: $_countdown",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Happy Valentine's Day message appears ABOVE the heart
                    if (_showValentineMessage)
                      Column(
                        children: [
                          Text(
                            "💖 Happy Valentine's Day! 💖",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cursive",
                              color: valentineTextColor,
                              shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15), // Add space before heart
                        ],
                      ),

                    // Heartbeat Image Animation with Glow Effect
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.6),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ScaleTransition(
                        scale: _animation,
                        child: Image.asset(
                          heartImageAsset,
                          width: 180,
                          height: 180,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Love Quotes (Always Visible Below Heart)
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(seconds: 2),
                      child: Text(
                        currentQuote,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 30),

                    if (!_showValentineMessage)
                      ElevatedButton(
                        onPressed: startCountdown,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text("Start ❤️", style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}