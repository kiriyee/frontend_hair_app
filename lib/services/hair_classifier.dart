import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class HairClassifier {
  // 1. Change 'late' to nullable '?' so we can check if it's ready
  Interpreter? _interpreter;
  final int inputSize = 300;

  final List<String> labels = ["Straight", "Wavy", "Curly"];

  HairClassifier() {
    _loadModel(); // Start loading, but we won't assume it finishes instantly
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/hair_model.tflite');
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<Map<String, dynamic>> predictImage(String imagePath) async {
    // 2. SAFETY CHECK: Ensure model is loaded before using it
    if (_interpreter == null) {
      print("Interpreter not ready, waiting...");
      await _loadModel();
    }

    // If it's still null after waiting, we have a real problem
    if (_interpreter == null) {
      throw Exception("Failed to load the AI model.");
    }

    final bytes = await File(imagePath).readAsBytes();
    final img.Image? decoded = img.decodeImage(bytes);

    // 3. SAFETY CHECK: Ensure image was actually decoded
    if (decoded == null) {
      throw Exception("Could not decode image. The format might not be supported.");
    }

    final resized = img.copyResize(decoded, width: inputSize, height: inputSize);

    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    final output = List.generate(1, (_) => List<double>.filled(labels.length, 0));

    // Use the nullable interpreter with '!' since we checked it above
    _interpreter!.run(input, output);

    final scores = output[0];
    final maxIndex = scores.indexWhere((v) => v == scores.reduce((a, b) => a > b ? a : b));

    return {
      "hairType": labels[maxIndex],
      "confidence": scores[maxIndex] * 100,
    };
  }
}