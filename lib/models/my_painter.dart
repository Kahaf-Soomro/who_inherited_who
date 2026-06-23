import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:who_inherited_who/models/touch_points.dart';


class MyPainter extends CustomPainter{
MyPainter({required this.pointslist});
List<TouchPoints> pointslist;
List<Offset> offsetPOINTS = [];

  @override
  void paint(Canvas canvas, Size size) {

    //painting logic here
    Paint background = Paint()..color = Colors.white;
    Rect rect =  Rect.fromLTWH(0,0, size.width, size.height);

  canvas.drawRect(rect, background);
  canvas.clipRect(rect); //try ClipRRect as well
  // logic for ppoitns 
  for(int i = 0; i<pointslist.length-1; i++){
      if(pointslist[i]!=null && pointslist[i+1]!=null)
      {
          //two points measn draw line
          canvas.drawLine(pointslist[i].points, pointslist[i+1].points, pointslist[i].paint);
        print('line drawn');
      // ignore: dead_code
      } if(pointslist[i]!=null && pointslist[i+1]==null){
        print('point drawn');
        offsetPOINTS.clear();
        offsetPOINTS.add(pointslist[i].points);
  offsetPOINTS.add(Offset(pointslist[i].points.dx+0.1, pointslist[i].points.dy+0.1));
    
    canvas.drawPoints(ui.PointMode.points,offsetPOINTS,pointslist[i].paint);
    
      }else{

      }
  }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
  
   return true;
   
  }



}