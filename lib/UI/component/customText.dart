import 'package:flutter/material.dart';

class MyText extends StatelessWidget {

  final String text;
  final double size;
  final Color color ;
  final FontWeight weight ;
  final TextAlign align ;




  MyText(
      {@required this.text,@required this.size,this.color :Colors.black
        ,this.weight:FontWeight.normal,this.align:TextAlign.center});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width ;

    return Text(text,style: TextStyle(
      fontSize: size,color: color,fontWeight: weight,),textDirection: TextDirection.ltr
        ,textAlign:align);
  }
}