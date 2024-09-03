import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';
import 'home_page.dart';


void main() {
  setupDependency();
  runApp(const MyApp());
}

void setupDependency(){
  Get.put<HomeController>(HomeController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo list',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.green,
          ),
        appBarTheme:  AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.yellow.shade700,
        )
      ),
      home: const HomePage(),
    );
  }
}
