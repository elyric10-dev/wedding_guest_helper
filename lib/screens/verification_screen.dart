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

      final response = await http.get(
        Uri.parse('https://api-rsvp.elyricm.cloud/api/invitation/$invitationCode'),
      );

      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final invitationData = responseData['invitation'];

        // Check if 'guests' key exists and is a list
        if (invitationData.containsKey('guests') && invitationData['guests'] is List) {
          setState(() {
            validGuests = invitationData['guests'];// Log raw guests data

            isValidGuest = validGuests.isNotEmpty;

            tableNumber = invitationData['seat_count'].toString();
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
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset(
                                //   'assets/images/ES_logo.png',
                                //   width: 200,
                                // ),
                                Image.asset(
                                  'assets/images/ES_logo.png',
                                  width: 200,
                                  // height: 200,
                                ),
                              ],
                            )
                          )
                        )
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
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
                    ),
                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.purple,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Table No: ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      tableNumber,
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: (MediaQuery.of(context).size.height - 200) / 2,
                        color: Colors.transparent,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
                          itemCount: validGuests.length,
                          itemBuilder: (context, index) {
                            final guest = validGuests[index];
                            return Card(
                              color: Colors.white,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  child: Text(
                                    '${guest['name'][0]}${guest['lastname'][0]}', // First letters of first and last name
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${guest['name']} ${guest['lastname']}', // Full name
                                  style: const TextStyle(
                                    color: Colors.purple,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
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
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Okay',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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