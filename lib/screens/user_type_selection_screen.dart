import 'package:flutter/material.dart';
import 'compounder_signup_screen.dart';
import 'company_signup_screen.dart'; // <-- Import this

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  int selectedIndex = 0;

  final List<_UserTypeOption> userTypes = [
    _UserTypeOption(
      title: 'Informal Collector',
      description: 'Sell recyclables near you and get paid fast',
      imagePath: 'assets/images/informal_icon.png',
      titleColor: Color(0xFFE04B2A),
      cardColor: Color(0xFFFDEEE8),
      borderColor: Color(0xFFE04B2A),
    ),
    _UserTypeOption(
      title: 'Compounder (Dealer)',
      description: 'Buy in bulk, connect with both collectors and companies',
      imagePath: 'assets/images/compounder_icon.png',
      titleColor: Color(0xFF1976D2),
      cardColor: Color(0xFFF3F6FF),
      borderColor: Color(0xFF1976D2),
    ),
    _UserTypeOption(
      title: 'Company',
      description: 'Find trusted dealers and purchase recyclables with ease',
      imagePath: 'assets/images/company_icon.png',
      titleColor: Color(0xFF34A853),
      cardColor: Color(0xFFF1FAEE),
      borderColor: Color(0xFF34A853),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 36),
            const Text(
              'Who Are You?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF11333D),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Choose how you want to use\nRecycle App',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF607180),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 34),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: userTypes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final option = userTypes[index];
                  final selected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 170),
                      curve: Curves.ease,
                      decoration: BoxDecoration(
                        color: option.cardColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: selected ? option.borderColor : Colors.transparent,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Image.asset(
                              option.imagePath,
                              width: 44,
                              height: 44,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: option.titleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    option.description,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF425663),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: selected
                                ? Container(
                              decoration: BoxDecoration(
                                color: option.titleColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.check, color: Colors.white, size: 22),
                            )
                                : const SizedBox(width: 26, height: 26),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final selected = userTypes[selectedIndex];

                    if (selected.title.contains('Compounder')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CompounderSignUpScreen()),
                      );
                    } else if (selected.title.contains('Informal')) {
                      Navigator.pushNamed(context, '/collector_signup');
                    } else if (selected.title.contains('Company')) {
                      Navigator.pushNamed(context, '/company_signup'); // ✅ updated line
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTypeOption {
  final String title;
  final String description;
  final String imagePath;
  final Color titleColor;
  final Color cardColor;
  final Color borderColor;

  const _UserTypeOption({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.titleColor,
    required this.cardColor,
    required this.borderColor,
  });
}
