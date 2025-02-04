import 'package:flutter/material.dart';
import 'package:verifier/components/flying_particles.dart';
import 'package:verifier/screens/scanner_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const VerifierApp());
}

class VerifierApp extends StatelessWidget {
  const VerifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SeatFinderScreen(),
    );
  }
}

class SeatFinderScreen extends StatelessWidget {
  const SeatFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5E6DA), // Beige background color
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Heading
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.greatVibes(
                            fontSize: 72,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Please scan your QR Code',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aboreto(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Circular QR Scanner
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // QR Scanner
                          const ClipOval(
                            child: SizedBox(
                              width: 280,
                              height: 280,
                              child: ScannerScreen(),
                            ),
                          ),

                          // Border image
                          Container(
                            width: 320,
                            height: 320,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/scanner_bg.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Carousel Images
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 380,
                        autoPlay: true, // Enables auto-sliding
                        autoPlayInterval: const Duration(seconds: 3), // Slide every 3 seconds
                        autoPlayAnimationDuration: const Duration(milliseconds: 800), // Smooth transition
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true, // Makes center image stand out
                        viewportFraction: 0.95, // Controls width of each image
                      ),
                      items: List.generate(25, (index) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/esw${25 - index}.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),

                  // Footer
                  const SizedBox(height: 28),
                  Text(
                    'Elyric & Sandy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.greatVibes(
                      fontSize: 56,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            ),
          ),
        ],
      )
    );
  }
}
