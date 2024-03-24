import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   final String text;
  final VoidCallback onPressed;
  final Color leftColor;
  final Color rightColor;
  
  const CustomButton({super.key,required this.text,
    required this.onPressed,
    this.leftColor = Colors.lightBlue,
    this.rightColor = Colors.blue,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60, 
        width:250,
        margin: const EdgeInsets.all(10),
       
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [leftColor, rightColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30), 
        ),
        child: Center(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}