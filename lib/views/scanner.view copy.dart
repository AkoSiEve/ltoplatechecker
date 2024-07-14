// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
            Container(
              child: !_cameraController.value.isInitialized
                  ? Text("false")
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 200,
                      height: 200,
                      child: AspectRatio(
                          // aspectRatio: 9 / 16,
                          aspectRatio: 1 / _cameraController.value.aspectRatio,
                          child: CameraPreview(_cameraController)),
                    ),
            )
          ],
        ),
      ),
    );
  }
}


// https://github.com/lynrin/Google-Ml-Kit-plugin/tree/master
// https://www.youtube.com/watch?v=HJWrxWVbckg