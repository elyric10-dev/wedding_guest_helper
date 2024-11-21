import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatefulWidget {
  final String scannedData;

  const ResultScreen({super.key, required this.scannedData});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _splitController;
  late Animation<double> _splitAnimation;
  bool showContent = false;

  @override
  void initState() {
    super.initState();

    // Controller for check mark animation
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Controller for split animation
    _splitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Split animation
    _splitAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _splitController,
      curve: Curves.easeInOut,
    ));

    // Sequence the animations
    _checkController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showContent = true;
        });
        _splitController.forward();
      });
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _splitController.dispose();
    super.dispose();
  }

  List<String> _parseData() {
    // Assuming the scanned data is comma-separated
    return widget.scannedData.split(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Content
          if (showContent)
            AnimatedBuilder(
              animation: _splitAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    // Top half
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.5,
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Transform.translate(
                            offset: Offset(0, -_splitAnimation.value * 100),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: Text(
                                  'Verified Names',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Bottom half
                    ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 0.5,
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Transform.translate(
                            offset: Offset(0, _splitAnimation.value * 100),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _parseData().length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Text('${index + 1}'),
                                    ),
                                    title: Text(_parseData()[index].trim()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

          // Check animation overlay
          if (!showContent)
            Center(
              child: Lottie.asset(
                'assets/check_animation.json',
                controller: _checkController,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }
}