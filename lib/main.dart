import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uitraning/mulity_select/widget/mulity_select.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MultiSelectComponent(
            options: const [
              'ahmed',
              'ragab',
              'salah',
              'yasser',
              'mohamed',
              'farage',
              'mostafa',
              'Mohamed Elshimi',
              'Sief Hesham'
            ],
            selectedIndexes: const [
              //inital selected indexes
            ],

            onSelectionChanged: (selectedIndexes) {
              //indexs of the selected options
              log(selectedIndexes.toString());
            },
          ),
        ),
      ),
    );
  }
}
