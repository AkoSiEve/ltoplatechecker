import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ltoplatechecker/views/home.view.dart';
import 'package:ltoplatechecker/views/scanner.view.dart';

late List<CameraDescription> _cameras;
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your v .
  @override
  Widget build(BuildContext context) {
    final firstcamera = _cameras.first;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(),
      // home: ScannerView(camera: firstcamera),
    );
  }
}


//TUTORIAL
// https://www.youtube.com/watch?v=s8DR0kHytSo&list=PL0aoTDj9Nwghdp04hgPPSC8pSzgOkyCXS&index=3