import 'dart:io';

import 'package:flutter/material.dart';
import 'view_similar.dart'; // Import the new page

class AssessmentResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  final File? selectedImage;

  AssessmentResultScreen({required this.result, this.selectedImage});

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
                  height: 65,
                  width: 65,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Text("نسبة خطأ الطرف الأول: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${result['party_one_fault']}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(
                        color: Colors.black
                      ),
                      Text("نسبة خطأ الطرف الثاني: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${result['party_two_fault']}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Divider(
                        color: Colors.black
                      ),
                      SizedBox(height: 20,),
                      Text('سبب القرار:',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${result['justification']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ArabicFont',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewSimilarScreen(result:result , selectedImage: selectedImage)),
                            );
                          },
                          child: Text('قضايا مشابهة',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'ArabicFont',
                              fontWeight: FontWeight.w400,
                        ),
                        ),
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
