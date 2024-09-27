import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/books_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });
    if (_isCameraPermissionGranted) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final firstCamera = cameras.first;
        _controller = CameraController(
          firstCamera,
          ResolutionPreset.medium,
        );
        _initializeControllerFuture = _controller.initialize();
        setState(() {});
      } else {
        throw Exception('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<String> performOCR(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return Scaffold(
        appBar: AppBar(title: Text('Kamera')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Izin kamera diperlukan untuk menggunakan fitur ini.'),
              ElevatedButton(
                onPressed: _requestCameraPermission,
                child: Text('Minta Izin Kamera'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Kamera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            print('Gambar diambil: ${image.path}');
            String bookTitle = await performOCR(image.path);
            print('Judul Buku: $bookTitle');
            final response = await BookService.getBookByTitle(bookTitle);
            print('Response dari API: $response');
          } catch (e) {
            print('Error taking picture: $e');
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
