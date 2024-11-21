import 'package:flutter/material.dart';
import 'package:verifier/screens/scanner_screen.dart';

// Guest model to represent each guest object


late final String tableNumber;
const Color beige = Color(0xFFF5F5DD);
const Color lilac = Color(0xFFB57EDC);
const Color darkLilac = Color(0xFF8B72BE);
const Color softLilac = Color(0xFFCAB9D9);
const Color champagne = Color(0XFFF5E7D1);

class Guest {
  final String id;
  final String name;
  final String lastname;

  Guest({required this.id, required this.name, required this.lastname});
}

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
  Guest? foundGuest;

  //example this is the return of the API
  final List<Guest> validGuests = [
    Guest(id: '10001', name: 'Rhine Heart', lastname: 'Garcia'),
    Guest(id: '10002', name: 'Melody', lastname: 'Dupal'),
    Guest(id: '10003', name: 'Emily', lastname: 'Davis'),
    Guest(id: '10004', name: 'Emma', lastname: 'Wilson'),
    Guest(id: '10005', name: 'Sophia', lastname: 'Anderson'),
  ];

  String tableNumber = '10'; // replace on integration

  @override
  void initState() {
    super.initState();

    // Verify the scanned QR code
    // foundGuest = validGuests as Guest?;

    isValidGuest = validGuests.isNotEmpty;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Colors.white),

          // Check/X Icon Animation
          if (!showList)
            AnimatedBuilder(
              animation: _checkAnimation,
              builder: (context, child) {
                return Center(
                  child: Transform.scale(
                    scale: _checkAnimation.value,
                    child: Icon(
                      isValidGuest ? Icons.check_circle : Icons.cancel,
                      color: isValidGuest ? Colors.green : Colors.red,
                      size: 150,
                    ),
                  ),
                );
              },
            ),

          // Content
          if (showList && isValidGuest)
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    // Top Half
                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.white,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Text(
                              'Elyric ♥ Sandy',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: lilac,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Table Number
                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: lilac,
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
                                    color: beige,
                                  ),
                                ),
                                Container(
                                  width: 80,  // Adjust as needed
                                  height: 80, // Adjust as needed
                                  decoration: const BoxDecoration(
                                    color: beige,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      tableNumber,
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: lilac, // beige color
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

                    // Welcome Guests
                    Transform.translate(
                      offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.white,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Text(
                              'Welcome have a seat!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: darkLilac,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Guest List
                    Transform.translate(
                      offset: Offset(0, 100 * (1 - _slideAnimation.value)),
                      child: Container(
                        height: (MediaQuery.of(context).size.height - 150) / 2,
                        color: Colors.transparent,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
                          itemCount: validGuests.length,
                          itemBuilder: (context, index) {
                            final guest = validGuests[index];
                            return Card(
                              color: beige,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white70,
                                      softLilac
                                    ],
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: darkLilac,
                                    child: Text(
                                      '${guest.name[0]}${guest.lastname[0]}', // First letters of first and last name
                                      style: const TextStyle(
                                        color: beige,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${guest.name} ${guest.lastname}', // Full name
                                    style: const TextStyle(
                                      color: darkLilac,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Total Tables and Scan New Code Button

                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 60, right: 60),
                      child: Transform.translate(
                        offset: Offset(0, 100 * (1 - _slideAnimation.value)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const ScannerScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  lilac,
                                  softLilac
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
                              alignment: Alignment.center,
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
                      ),
                    ),
                  ],
                );
              },
            ),

          // Invalid Guest Screen
          if (showList && !isValidGuest)
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
                  const Text(
                    'Invalid QR Code',
                    style: TextStyle(
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
                        MaterialPageRoute(builder: (context) => const ScannerScreen()),
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