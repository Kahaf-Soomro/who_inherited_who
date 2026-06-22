import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TouchPoints
{
  Paint paint;
  Offset points;
  TouchPoints({required this.paint , required this.points});

  Map<String, dynamic> toJSON(){
        return {'point':{'dx':'${points.dx}', 'dy':'${points.dy}' }};
  }
}