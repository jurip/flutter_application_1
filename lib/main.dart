import 'package:flutter/material.dart';
import 'src/screens/image_grid_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Grid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ImageGridScreen(),
    );
  }
}