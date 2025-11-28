import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class HairClassifier {
  late Interpreter _interpreter;
  final int inputSize = 300;

  final List<String> labels = ["Straight", "Wavy", "Curly"];

  HairClassifier() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('model/hair_model.tflite');
  }

  Future<Map<String, dynamic>> predictImage(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final img.Image? decoded = img.decodeImage(bytes);

    final resized = img.copyResize(decoded!, width: inputSize, height: inputSize);

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

    _interpreter.run(input, output);

    final scores = output[0];
    final maxIndex = scores.indexWhere((v) => v == scores.reduce((a, b) => a > b ? a : b));

    return {
      "type": labels[maxIndex],
      "confidence": scores[maxIndex] * 100,
    };
  }
}
