import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:verifier/main.dart';
import 'dart:convert';

class VerificationScreen extends StatefulWidget {
  final String scannedData;

  const VerificationScreen({super.key, required this.scannedData});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _checkAnimation;
  late Animation<double> _slideAnimation;
  bool showList = false;
  bool isValidGuest = false;
  List<dynamic> validGuests = []; // Change to List<dynamic>
  String tableNumber = '';
  bool isLoading = true;
  bool isNetworkError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchGuestsByInvitationCode();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2700),
      vsync: this,
    );

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1, curve: Curves.easeInOut),
      ),
    );

    _controller.addListener(() {
      if (_controller.value >= 0.7 && !showList) {
        setState(() {
          showList = true;
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchGuestsByInvitationCode() async {
    try {
      final Map<String, dynamic> scannedQrData = json.decode(widget.scannedData);
      final String invitationCode = scannedQrData['code'];

      final response = await http.post(
        Uri.parse('https://api-rsvp.elyricm.cloud/api/scan-qr/$invitationCode'),
      );

      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // final invitationData = responseData['invitation'];

        if (responseData['arrived_guests'] is List) {
          setState(() {
            validGuests = responseData['arrived_guests'];

            isValidGuest = validGuests.isNotEmpty;

            tableNumber = responseData['arrived_guests'] != null &&
                responseData['arrived_guests'].isNotEmpty &&
                responseData['arrived_guests'][0]['table_id'] != null
                ? responseData['arrived_guests'][0]['table_id'].toString()
                : '0';
            isLoading = false;
          });
        } else {
          setState(() {
            isValidGuest = false;
            isLoading = false;
            isNetworkError = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load invitation. Status code: ${response.statusCode}';
          isLoading = false;
          isNetworkError = false;
        });
      }
    } catch (e) {
      isNetworkError = true;
      setState(() {
        errorMessage = 'Error connecting to the server';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.purple),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          if (!showList)
            AnimatedBuilder(
              animation: _checkAnimation,
              builder: (context, child) {
                return Center(
                  child: Transform.scale(
                    scale: _checkAnimation.value,
                    child: Icon(
                      isValidGuest ? Icons.check_circle : null,
                      color: isValidGuest ? Colors.purple : Colors.red,
                      size: 150,
                    ),
                  ),
                );
              },
            ),
          if (showList && isValidGuest)
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Text(
                        'Welcome!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.greatVibes(
                          fontSize: 72,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Text(
                              'Thank you for coming,',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aboreto(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'please be seated at',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aboreto(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )
                      ),
                    ),

                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: const Color(0xFFC8A2C8),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                'Table no.',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.aboreto(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 170,
                                    height: 170,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      tableNumber,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.aboreto(
                                        fontSize: 100,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.purple[300],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 320,
                                    height: 320,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/scanner_bg.png'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: (MediaQuery.of(context).size.height - 200) / 2.4,
                        color: Colors.transparent,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 0, right: 16, left: 16),
                          itemCount: validGuests.length,
                          itemBuilder: (context, index) {
                            final guest = validGuests[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0),
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/qr_list_border.png'),
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.centerLeft,
                                      opacity: 0.8,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 42,
                                      backgroundColor: Colors.purple[300],
                                      child: Text(
                                        '${guest['name'][0]}${guest['lastname'][0]}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.aboreto(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        '${guest['name']} ${guest['lastname']}',
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.aboreto(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.purple[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 60, right: 60),
                      child: Transform.translate(
                        offset: Offset(0, 100 * (1 - _slideAnimation.value)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SeatFinderScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC8A2C8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                            child: Text(
                              'Okay',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aboreto(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
                );
              },
            ),

          if (!isValidGuest && !isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                   Text(isNetworkError ? 'Check your Network or Server Connection.': 'Invalid QR Code',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SeatFinderScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Scan Again',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

        ],
      ),
    );
  }
}