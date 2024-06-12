import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccidentAssessmentScreen(),
    );
  }
}

class AccidentAssessmentScreen extends StatefulWidget {
  @override
  _AccidentAssessmentScreenState createState() =>
      _AccidentAssessmentScreenState();
}

class _AccidentAssessmentScreenState extends State<AccidentAssessmentScreen> {
  final TextEditingController _partyOneController = TextEditingController();
  final TextEditingController _partyTwoController = TextEditingController();
  String? _imgUrl;

  Future<void> _assessFault() async {

    if (_partyOneController.text.isEmpty || _partyTwoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide all the required inputs')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/assess_fault'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'party_one_description': _partyOneController.text,
        'party_two_description': _partyTwoController.text,
      }),
    );

    final result = json.decode(response.body);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fault Assessment'),
        content: Text('Party One Fault: ${result['party_one_fault']}%\n'
            'Party Two Fault: ${result['party_two_fault']}%\n'
            'Justification: ${result['justification']}'),
      ),
    );
  }

  //intiate cloudinary
  Future<String?> uploadImage(String imagePath) async {
    final cloudinary = Cloudinary.full(
      apiKey: '634863842981523',
      apiSecret: '7GwzeMp2rrnlO-s1I0_zJoriFJs',
      cloudName: 'dxz1w6uho',
    );

    try {
      final response = await cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: imagePath,
          resourceType: CloudinaryResourceType.image,
          optParams: {
            'quality': 'auto:best',
            'fetch_format': 'auto',
          },
        ),
      );

      if (response.isSuccessful) {
        final imgUrl = response.secureUrl;
        print('Image URL: $imgUrl');
        return imgUrl;
        // Use the imgUrl as needed
      } else {
        print('Upload failed: ${response.error}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }


  //Image picker function to get image from gallery
  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source:ImageSource.gallery);
    if(returnedImage == null) return;
    String? imageUrl = await uploadImage(returnedImage.path);
    print("======================================================================");
    print(imageUrl);
    print(returnedImage.path);
    setState(() {
      _imgUrl = imageUrl; // Store the image URL
    });
  }

  File ? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Accident Assessment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _partyOneController,
              decoration: InputDecoration(labelText: 'Party One Description'),
            ),
            TextField(
              controller: _partyTwoController,
              decoration: InputDecoration(labelText: 'Party Two Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _assessFault,
              child: Text('Assess Fault'),
            ),
            MaterialButton(
              child:  const Text("Upload Image"),
              onPressed: (){
                _pickImageFromGallery();
              },
            ),
            const SizedBox(height: 20,),
            _selectedImage != null ? Image.file(_selectedImage!) : Text("Please select an image")
          ],
        ),
      ),
    );
  }
}
