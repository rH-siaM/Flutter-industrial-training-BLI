import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IUT ID Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = 300.0;
            final avatarWidth = 90.0;
            final avatarLeft = (cardWidth / 2) - (avatarWidth / 2);

            return Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: cardWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff003432),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 16, bottom: 60),
                          child: Column(
                            children: [
                              Image.asset("assets/images/iut_logo.png", height: 90),
                              Text(
                                "ISLAMIC UNIVERSITY OF TECHNOLOGY",
                                style: GoogleFonts.oswald(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Avatar (overlapping)
                        Positioned(
                          bottom: -50,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff003432),
                                width: 6,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1),
                              child: Image.asset(
                                "assets/images/avatar.png",
                                height: 100,
                                width: avatarWidth,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50), // space below avatar
                    Padding(
                      padding: EdgeInsets.only(
                        left: avatarLeft,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          InfoRow(
                            icon: Icons.key,
                            label: "Student ID",
                            value: "210041266",
                            //isStacked: true,
                          ),
                          InfoRow(
                            icon: Icons.person,
                            label: "Student Name",
                            value: "RUBAEEYAT HOSSAIN",
                            isBold: true,
                            isStacked: true,
                          ),
                          InfoRow(
                            icon: Icons.school,
                            label: "Program",
                            value: "B.Sc. in CSE",
                          ),
                          InfoRow(
                            icon: Icons.account_tree,
                            label: "Department",
                            value: "CSE",
                          ),
                          InfoRow(
                            icon: Icons.location_on,
                            label: "Bangladesh",
                            value: "",
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff003432),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "A subsidiary organ of OIC",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;
  final bool isStacked;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
    this.isStacked = false,
  });

  @override
  Widget build(BuildContext context) {
    // Special design for Student ID row
    // Special design for Student ID row
if (label == "Student ID") {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // align top of icon with top of Column
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
    const SizedBox(height: 4),
    // Align pill with the icon
    Transform.translate(
  offset: const Offset(-26, 0), // move left by 26
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    decoration: const ShapeDecoration(
      color: Color(0xff003432),
      shape: StadiumBorder(),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2B7EFF),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ],
    ),
  ),
)

  ],
),

      ],
    ),
  );
}

    // Default layout for other rows
    if (isStacked) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight:
                          isBold ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 6),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black87, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "$label ",
                      style:
                          const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontWeight: isBold
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

