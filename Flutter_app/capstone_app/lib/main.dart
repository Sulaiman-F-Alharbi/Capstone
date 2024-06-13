import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'assessment_result_screen.dart';
import 'loading_screen.dart';
import 'welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class AccidentAssessmentScreen extends StatefulWidget {
  @override
  _AccidentAssessmentScreenState createState() => _AccidentAssessmentScreenState();
}

class _AccidentAssessmentScreenState extends State<AccidentAssessmentScreen> {
  final TextEditingController _partyOneController = TextEditingController();
  final TextEditingController _partyTwoController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  String _imageStatus = '';

  Future<void> _assessFault() async {
    setState(() {
      _isLoading = true;
    });

    // Encode the selected image
    Uint8List _bytes = await _selectedImage!.readAsBytes();
    String _imageBase64 = base64.encode(_bytes);

    if (_partyOneController.text.isEmpty || _partyTwoController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide all the required inputs')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/assess_fault'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: json.encode({
        'party_one_description': _partyOneController.text,
        'party_two_description': _partyTwoController.text,
        'image': _imageBase64,
      }),
    );

    final decodedJson = utf8.decode(response.bodyBytes);
    final result = json.decode(decodedJson);
    print(result['image']);

    setState(() {
      _isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssessmentResultScreen(result: result, selectedImage: _selectedImage),
      ),
    );
  }

  // Image picker function to get image from gallery
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path); // Store the image URL
      _imageStatus = 'تم رفع الصورة'; // Update the image status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple.shade200], // Define the gradient colors
                begin: Alignment.topLeft, // Start point of the gradient
                end: Alignment.bottomRight, // End point of the gradient
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                toolbarHeight: 60,
                centerTitle: true,
                title: Image.asset(
                    'assets/app_logo.jpg',
                    fit: BoxFit.contain,
                    height: 65,
                    width: 65,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          "أهلا بك في\nأنـجـز",
                          style: TextStyle(
                            fontSize: 35,
                            fontFamily: 'ArabicFont',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _partyOneController,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(labelText: 'وصف الطرف الأول'),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextField(
                        controller: _partyTwoController,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(labelText: 'وصف الطرف الثاني'),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              child: const Text("رفع صورة",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'ArabicFont',
                                    fontWeight: FontWeight.w400,
                                  ),
                              ),
                              onPressed: () {
                                _pickImageFromGallery();
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              _imageStatus,
                             style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'ArabicFont',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade700,
                                  ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _assessFault,
                              child: Text('تقدير نسبة الخطأ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'ArabicFont',
                                    fontWeight: FontWeight.w400,
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              resizeToAvoidBottomInset: true,
            ),
          ),
          if (_isLoading)
            LoadingScreen(), // Display the loading screen when loading
        ],
      ),
    );
  }
}
