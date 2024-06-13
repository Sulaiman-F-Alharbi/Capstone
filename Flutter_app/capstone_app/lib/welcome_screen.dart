import 'package:flutter/material.dart';
import 'main.dart'; // Import the file where AccidentAssessmentScreen is defined

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  
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
        body:Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage(
                  'assets/app_logo.jpg'),
                ),
              ),
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccidentAssessmentScreen()),
                );
              },
              child: Text('ابدأ',
              style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'ArabicFont',
                      fontWeight: FontWeight.w400,
                    ),),
            ),
            
          ],
        ),
      ),
      ),
    );
  }
}
