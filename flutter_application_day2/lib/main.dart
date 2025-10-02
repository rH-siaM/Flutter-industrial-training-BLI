import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

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

class StudentData {
  final String id;
  final String name;
  final String program;
  final String department;
  final Uint8List? imageBytes;

  StudentData({
    required this.id,
    required this.name,
    required this.program,
    required this.department,
    this.imageBytes,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color primaryColor = const Color(0xff003432);
  String currentFont = 'Oswald';
  final List<String> fontOptions = [
    'Oswald',
    'Roboto',
    'Lato',
    'Poppins',
    'Merriweather',
    'Montserrat',
    'Raleway',
  ];

  StudentData? studentData;

  void randomizeStyle() {
    final random = Random();
    setState(() {
      primaryColor = Color.fromARGB(
        255,
        0,
        100 + random.nextInt(155),
        0,
      );
      currentFont = fontOptions[random.nextInt(fontOptions.length)];
    });
  }

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (context) => StudentInputDialog(
        onSubmit: (data) {
          setState(() {
            studentData = data;
          });
        },
        currentData: studentData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'edit',
            backgroundColor: primaryColor,
            onPressed: _showInputDialog,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'refresh',
            backgroundColor: primaryColor,
            onPressed: randomizeStyle,
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: studentData == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.badge, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No ID Card Created',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _showInputDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Create ID Card'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              )
            : IDCardWidget(
                studentData: studentData!,
                primaryColor: primaryColor,
                currentFont: currentFont,
              ),
      ),
    );
  }
}

class StudentInputDialog extends StatefulWidget {
  final Function(StudentData) onSubmit;
  final StudentData? currentData;

  const StudentInputDialog({
    super.key,
    required this.onSubmit,
    this.currentData,
  });

  @override
  State<StudentInputDialog> createState() => _StudentInputDialogState();
}

class _StudentInputDialogState extends State<StudentInputDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _programController;
  late TextEditingController _deptController;
  
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.currentData?.id ?? '');
    _nameController = TextEditingController(text: widget.currentData?.name ?? '');
    _programController = TextEditingController(text: widget.currentData?.program ?? 'B.Sc. in CSE');
    _deptController = TextEditingController(text: widget.currentData?.department ?? 'CSE');
    _selectedImageBytes = widget.currentData?.imageBytes;
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _programController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedImageBytes = result.files.first.bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Student Information'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImageBytes == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Add Photo', style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.memory(
                            _selectedImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.key),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _programController,
                decoration: const InputDecoration(
                  labelText: 'Program',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter program';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _deptController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_tree),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                StudentData(
                  id: _idController.text,
                  name: _nameController.text.toUpperCase(),
                  program: _programController.text,
                  department: _deptController.text,
                  imageBytes: _selectedImageBytes,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Create Card'),
        ),
      ],
    );
  }
}

class IDCardWidget extends StatelessWidget {
  final StudentData studentData;
  final Color primaryColor;
  final String currentFont;

  const IDCardWidget({
    super.key,
    required this.studentData,
    required this.primaryColor,
    required this.currentFont,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = 300.0;
    final avatarWidth = 90.0;
    final avatarLeft = (cardWidth / 2) - (avatarWidth / 2);

    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.getFont(
          currentFont,
          fontSize: 14,
          color: Colors.black87,
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
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 16, bottom: 60),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/iut_logo.png",
                          height: 90,
                        ),
                        Text(
                          "ISLAMIC UNIVERSITY OF TECHNOLOGY",
                          style: GoogleFonts.getFont(
                            currentFont,
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
                          color: primaryColor,
                          width: 6,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: studentData.imageBytes != null
                            ? Image.memory(
                                studentData.imageBytes!,
                                height: 100,
                                width: avatarWidth,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 100,
                                width: avatarWidth,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.only(
                  left: avatarLeft,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(
                      icon: Icons.key,
                      label: "Student ID",
                      value: studentData.id,
                    ),
                    InfoRow(
                      icon: Icons.person,
                      label: "Student Name",
                      value: studentData.name,
                      isBold: true,
                      isStacked: true,
                    ),
                    InfoRow(
                      icon: Icons.school,
                      label: "Program",
                      value: studentData.program,
                    ),
                    InfoRow(
                      icon: Icons.account_tree,
                      label: "Department",
                      value: studentData.department,
                    ),
                    const InfoRow(
                      icon: Icons.location_on,
                      label: "Bangladesh",
                      value: "",
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff003432),
                  borderRadius: BorderRadius.only(
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
    final baseStyle = DefaultTextStyle.of(context).style;

    if (label == "Student ID") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: baseStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Transform.translate(
                  offset: const Offset(-26, 0),
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
                          style: baseStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

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
                  style: baseStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: baseStyle.copyWith(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

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
                style: baseStyle,
                children: [
                  TextSpan(
                    text: "$label ",
                    style: baseStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: value,
                    style: baseStyle.copyWith(
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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