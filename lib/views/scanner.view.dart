// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ltoplatechecker/utils/global.colors.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;
  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late CameraController _cameraController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initCamera(widget.camera);
    // Timer.periodic(Duration(seconds: 2), (Timer t) => _takePIcture());
  }

  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  initCamera(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.low);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SafeArea(
    //     child: Container(
    //       color: Colors.red,
    //       padding: EdgeInsets.all(25),
    //       width: double.infinity,
    //       alignment: Alignment.center,
    //       height: 300,
    //       child: AspectRatio(
    //         aspectRatio: 4 / 3,
    //         child: Container(
    //           // color: Colors.blueGrey,
    //           child: _cameraController.value.isInitialized
    //               ? CameraPreview(_cameraController)
    //               : Text("false"),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //IMAGE BACKGROUND
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg_crossroads.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null,
            ),
            //LIGHBLUE BACJGROUND //
            Container(
              // color: GlobalColors.colorBlue.withOpacity(0.75),
              color: Color.fromRGBO(0, 54, 175, .75),
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, right: 15),
              // height: double.infinity,
              height: 1065,
              child: null,
            ),
            //NAV
            Container(
              alignment: Alignment.centerLeft,
              color: GlobalColors.colorBlue,
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 70,
              child: Image.asset(
                "assets/lto_logo.png",
                scale: 7,
              ),
              // child: InkWell(
              //   onTap: () {
              //     print("object");
              //     Get.back();
              //   },
              //   child: Icon(
              //     Icons.arrow_back,
              //     color: GlobalColors.colorRed,
              //     size: 30,
              //   ),
              // ),
            ),
            Container(
              child: !_cameraController.value.isInitialized
                  ? Text("")
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 120, left: 50, right: 50),
                              width: MediaQuery.of(context).size.width / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                ),
                                child: AspectRatio(
                                    // aspectRatio: 9 / 16,
                                    aspectRatio:
                                        1 / _cameraController.value.aspectRatio,
                                    child: CameraPreview(_cameraController)),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(top: 20, left: 40, right: 40),
                              width: double.infinity,
                              height: 50,
                              child: InkWell(
                                onTap: () {
                                  _takePIcture();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: GlobalColors.colorRed,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Scan",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            renewalDateMessage == ""
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(
                                        top: 20, left: 40, right: 40),
                                    width: double.infinity,
                                    // height: 200,
                                    // color: Colors.red,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        // color: GlobalColors.colorRed,
                                        color:
                                            const Color.fromARGB(255, 1, 110, 5)
                                                .withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "${renewalDateMessage}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        plateNumber == ""
                            ? Container()
                            : Positioned(
                                top: 120,
                                width: 300,
                                height: 410,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        // color: Colors.red,
                                        color: Colors.black45,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "${plateNumber}",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  _takePIcture() async {
    final image = await _cameraController.takePicture();
    final RecognizedText =
        await _processImage(InputImage.fromFile(File(image.path)));

    _validatePlateNumberText(RecognizedText);
  }

  _processImage(InputImage inputImage) async {
    try {
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);

//
      for (TextBlock block in recognizedText.blocks) {
        final Rect rect = block.boundingBox;
        final List<Point<int>> cornerPoints = block.cornerPoints;
        final String text = block.text;
        final List<String> languages = block.recognizedLanguages;

        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          print(line.text);
          if ((line.text.length > 2) &&
              (line.text.length <= 8) &&
              (line.confidence! >= 0.5)) {
            // print(
            //     "aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa ${element.confidence}");
            // print(
            //     "bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb ${element.text}");
            // return recognizedText.text;
            print(
                "dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd ${line.boundingBox}");
            return line.text;
          }
          for (TextElement element in line.elements) {
            // Same getters as TextBlock
            print(element.text);
            // if ((element.text.length > 2) &&
            //     (element.text.length <= 8) &&
            //     (element.confidence! >= 0.5)) {
            //   // print(
            //   //     "aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa ${element.confidence}");
            //   // print(
            //   //     "bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb ${element.text}");
            //   // return recognizedText.text;
            //   print(
            //       "dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd dd ${element.boundingBox}");
            //   return element.text;
            // }
          }
        }
      }
//

      // return recognizedText.text;
      return "";
    } catch (e) {
      return null;
    }
  }

  late String plateNumber = "";

  _validatePlateNumberText(String RecognizedText) {
    //NBC 1234
    // final regexPlateNumber = RegExp(r'^([A-Z0-9]{3}|)+$');
    final regexPlateNumber = RegExp(r'^[A-Z]{3}(-|\s*)\d{4}$');
    // final firstPattern;
    // final secondPattern;
    // final getCharacter = RecognizedText.replaceAll(RegExp(r"\d|."), "");
    final getCharacter = RecognizedText.replaceAll(RegExp("[^A-Za-z]"), "");
    final getNumber = RecognizedText.replaceAll(RegExp(r"\D"), "");

    // if (RecognizedText == null || RecognizedText == "") return;
    setState(() {
      plateNumber = RecognizedText;
    });
    print(
        "aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa ${RecognizedText}");

    // if (getCharacter == null || getCharacter == "") return;
    print(
        "bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb ${getCharacter}");
    if (getNumber == null ||
        getNumber == "" ||
        RecognizedText == null ||
        RecognizedText == "" ||
        getCharacter == null ||
        getCharacter == "") {
      _ressetingValue();
      return;
    }

    print("cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc ${getNumber}");

    _pnExpirationDateCalculation(getNumber);
  }

  late String renewalDateMessage = "";

  //calculation for plate number expiration date
  _pnExpirationDateCalculation(String num) {
    List<String> months = [
      "October",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",

      // "November",
      // "December"
    ];
    try {
      final getLastDigit = num.substring(num.length - 1);
      final getSecondDigit = num.substring(num.length - 2, num.length - 1);

      print(
          "ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ${getLastDigit}");
      print("months : ${months[int.parse(getLastDigit)]}");

      switch (int.parse(getSecondDigit)) {
        case 1:
        case 2:
        case 3:
          // print("1st seven days of the months");
          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 1st week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 1st week of ${months[int.parse(getLastDigit)]}");
          break;
        case 4:
        case 5:
        case 6:
          // print("2nd seven days of the months");
          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 2nd week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 2nd week of ${months[int.parse(getLastDigit)]}");
          break;
        case 7:
        case 8:
          // print("3rd seven days of the months");
          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 3rd week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 3rd week of ${months[int.parse(getLastDigit)]}");
          break;
        case 9:
        case 0:
          // print("4th seven days of the months");
          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 4th week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 4th week of ${months[int.parse(getLastDigit)]}");
          break;
        default:
      }
    } catch (e) {
      print("cxz");
    }
  }

  _ressetingValue() {
    setState(() {
      plateNumber = "";
      renewalDateMessage = "";
    });
  }
}

// https://github.com/lynrin/Google-Ml-Kit-plugin/tree/master
// https://www.youtube.com/watch?v=HJWrxWVbckg


