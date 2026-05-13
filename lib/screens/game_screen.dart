import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/smile_detection_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SmileDetectionService smileDetection;
  int slideCount = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    smileDetection = SmileDetectionService();
    await smileDetection.initializeCamera();
    _startGameLoop();
  }

  void _startGameLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return false;

      // Check if smile detected
      if (smileDetection.isSmiling && !gameOver) {
        setState(() {
          gameOver = true;
        });
        _showGameOver();
        return false;
      }

      return !gameOver;
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You Smiled! 😄'),
        content: Text('You lasted $slideCount slides.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      gameOver = false;
      slideCount = 0;
    });
    _startGameLoop();
  }

  @override
  void dispose() {
    smileDetection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0533),
      body: Stack(
        children: [
          // Camera feed
          if (!gameOver && smileDetection.cameraController.value.isInitialized)
            CameraPreview(smileDetection.cameraController),

          // Top HUD
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Slides: $slideCount',
                  style: const TextStyle(
                    color: Color(0xFFFFE135),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFFFFE135),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Smile detection indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: smileDetection.isSmiling
                      ? Colors.red.withOpacity(0.7)
                      : Colors.green.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  smileDetection.isSmiling ? 'Smile Detected! 😬' : 'Keep a Straight Face',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
