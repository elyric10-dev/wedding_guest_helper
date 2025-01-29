import 'package:flutter/material.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5E6DA), // Beige background color
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
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
                        fontSize: 48,  // Adjust size for elegance
                        fontWeight: FontWeight.w400,
                        color: Colors.black87, // Softer black for a classy look
                      ),
                    ),
                    Text(
                      'Please scan your QR Code',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aboreto(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54, // Lighter shade for subtlety
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 40),
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
                          width: 200,
                          height: 200,
                          child: ScannerScreen(),
                        ),
                      ),
                      // Border image
                      Container(
                        width: 280, // Slightly larger than the scanner
                        height: 280,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/scanner_bg.png'), // Change to your background image
                            fit: BoxFit.cover, // Ensures the image covers the circle
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 40),
              // Instructions
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Expanded(
              //         child: _buildInstructionColumn(
              //           Icons.phone_android,
              //           'Prepare your gate pass QR code',
              //         ),
              //       ),
              //       const SizedBox(width: 15),
              //       Expanded(
              //         child: _buildInstructionColumn(
              //           Icons.qr_code_scanner,
              //           'Place your QR code under the QR scanner',
              //         ),
              //       ),
              //       const SizedBox(width: 15),
              //       Expanded(
              //         child: _buildInstructionColumn(
              //           Icons.touch_app,
              //           'Check table number and Tap Okay',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 320, // Adjust height as needed
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
              const Spacer(),
              // Footer
              // const Padding(
              //   padding: EdgeInsets.only(bottom: 30),
              //   child: Text(
              //     'ELYRIC & SANDY',
              //     style: TextStyle(
              //       fontSize: 28,
              //       fontWeight: FontWeight.bold,
              //       letterSpacing: 4,
              //     ),
              //   ),
              // ),


              Text(
                'Elyric & Sandy',
                textAlign: TextAlign.center,
                style: GoogleFonts.greatVibes(
                  fontSize: 56,  // Adjust size for elegance
                  fontWeight: FontWeight.w400,
                  color: Colors.black87, // Softer black for a classy look
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildInstructionColumn(IconData icon, String text) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(color: Colors.grey.shade300),
  //         ),
  //         child: Icon(icon, size: 24),
  //       ),
  //       const SizedBox(height: 10),
  //       Text(
  //         text,
  //         style: const TextStyle(
  //           fontSize: 14,
  //           height: 1.5,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //     ],
  //   );
  // }
}
