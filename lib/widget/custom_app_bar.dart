import 'dart:convert';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final IconData leftIcon;
  final IconData rightIcon;
  
  final Function? leftCallback;
  const CustomAppBar(this.leftIcon,this.rightIcon,{super.key,this.leftCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top:MediaQuery.of(context).padding.top,
        left: 0,
        right: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
                leftCallback != null ? () => leftCallback!() : null;
              
            },
            child: _buildIcon(leftIcon),
          ),
          const Row(
            children: [
              Icon(Icons.access_alarm,color: Color.fromARGB(255, 59, 62, 207),size: 25,),
              Text("Time Clock",style: TextStyle(color:  Color.fromARGB(255, 95, 132, 235),fontWeight: FontWeight.bold,fontSize: 18 ),),
            ],
          ),
         
          
          _buildIcon(rightIcon),
           
        ],
      ),
    );
  }
  Widget _buildIcon(IconData icon){
    return Container(
      
      padding: const EdgeInsets.all(10),
      child: Icon(icon,color: Color.fromARGB(255, 93, 95, 247),size: 25,),
    );
  }
}