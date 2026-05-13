import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class SmileDetectionService {
  late CameraController cameraController;
  late FaceDetector faceDetector;
  
  bool isSmiling = false;
  bool isProcessing = false;

  SmileDetectionService() {
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableSmile: true,
        enableTracking: true,
      ),
    );
  }

  /// Initialize camera (call this in initState or onInit)
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize();
    startSmileDetection();
  }

  /// Continuously process frames for smile detection
  void startSmileDetection() {
    cameraController.startImageStream((CameraImage image) async {
      if (isProcessing) return;
      
      isProcessing = true;

      try {
        // Convert CameraImage to InputImage for ML Kit
        final inputImage = InputImage.fromBytes(
          bytes: _concatenatePlanes(image.planes),
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: InputImageRotation.rotation270deg,
            format: InputImageFormat.nv21,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );

        // Detect faces
        final faces = await faceDetector.processImage(inputImage);

        // Check if any face is smiling
        isSmiling = faces.any((face) => face.smilingProbability! > 0.7);
      } catch (e) {
        print('Smile detection error: $e');
      } finally {
        isProcessing = false;
      }
    });
  }

  /// Helper: concatenate image planes into single bytes list
  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().asUint8List();
  }

  /// Dispose camera and detector
  Future<void> dispose() async {
    await cameraController.stopImageStream();
    await cameraController.dispose();
    faceDetector.close();
  }
}

// Required import for WriteBuffer
import 'dart:typed_data';
import 'dart:ui';
