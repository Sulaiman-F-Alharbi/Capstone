import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class ViewSimilarScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  final File? selectedImage;

  ViewSimilarScreen({required this.result, this.selectedImage});

  @override
  _ViewSimilarScreenState createState() => _ViewSimilarScreenState();
}

class _ViewSimilarScreenState extends State<ViewSimilarScreen> {
  List<int> first_party_f = [];
  List<int> second_party_f = [];
  List<String> justifications = [];
  List<String> all_images = [];

  @override
  void initState() {
    super.initState();
    _getSimilar();
  }

  Future<void> _getSimilar() async {
    print('=============================================');
    widget.result['party_one_fault'] = widget.result['party_one_fault'].toString();
    widget.result['party_two_fault'] = widget.result['party_two_fault'].toString();

    if (widget.selectedImage == null) {
      print("No image selected");
      return;
    }

    // Encode the selected image
    Uint8List _bytes = await widget.selectedImage!.readAsBytes();
    String _imageBase64 = base64.encode(_bytes);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/get_similar'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({
          'party_one_description': widget.result['party_one_fault'],
          'party_two_description': widget.result['party_two_fault'],
          'image': _imageBase64,
        }),
      );

      if (response.statusCode == 200) {
        final decodedJson = utf8.decode(response.bodyBytes);
        final similar_list = json.decode(decodedJson);
        print("=====================Here=================");
        print(similar_list);
        
        setState(() {
          for (int i = 0; i < similar_list.length; i++) {
            first_party_f.add(similar_list[i]['firstParty_fault']);
            second_party_f.add(similar_list[i]['secondParty_fault']);
            justifications.add(similar_list[i]['justification']);
            // File temp = await base64ToFile(similar_list[i]['image'], 'image$i.png');
            // all_images.add(temp.path);
          }
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

// Function to convert base64 string to File
  Future<File> base64ToFile(String base64String, String fileName) async {
    // Decode the base64 string
    Uint8List bytes = base64.decode(base64String);

    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();

    // Create a file in the temporary directory
    File file = File('${tempDir.path}/$fileName');

    // Write the bytes to the file
    await file.writeAsBytes(bytes);

    return file;
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
                automaticallyImplyLeading: true, // Enable back button
                toolbarHeight: 60,
                centerTitle: true,
                title: Image.asset(
                  'assets/app_logo.jpg',
                  fit: BoxFit.contain,
                  height: 60,
                  width: 60,
                ),
              ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: first_party_f.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('نسبة خطأ الطرف الأول: ${first_party_f[index]}%'),
                                  Text('نسبة خطأ الطرف الثاني: ${second_party_f[index]}%'),
                                  Text('سبب القرار: ${justifications[index]}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ViewSimilarScreen(result: {
      'party_one_fault': '40',
      'party_two_fault': '60',
      'image': 'image_data',
      'justification': 'Some reason',
    }),
  ));
}
