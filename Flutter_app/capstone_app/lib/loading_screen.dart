import 'package:flutter/material.dart';
import 'dart:ui';


class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.5),  // Semi-transparent background
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),  // Blur effect
            child: Container(
              color: Colors.black.withOpacity(0.3),  // Slightly darker to enhance the blur
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [  
           
                Center(
                  child: Text("جاري التحليل...",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'ArabicFont',
                      fontWeight: FontWeight.w400,
                      color: Colors.purple
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
