import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pleasepleaseplease/pages/hair_analysis_results_page.dart';
import 'package:pleasepleaseplease/pages/image_error_page.dart';
import 'package:pleasepleaseplease/widgets/gradient_button.dart';
import 'package:pleasepleaseplease/services/hair_classifier.dart';
import '../default_styles/app_text_styles.dart';
import '../default_styles/app_colors.dart';
import 'package:lottie/lottie.dart';

class PhotoInstructionsPage extends StatefulWidget {
  const PhotoInstructionsPage({super.key});

  @override
  State<PhotoInstructionsPage> createState() => _PhotoInstructionsPageState();
}

class _PhotoInstructionsPageState extends State<PhotoInstructionsPage> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  late HairClassifier _classifier;

  @override
  void initState() {
    super.initState();
    _classifier = HairClassifier(); // initialize the model
  }

  //----------------------------------------------------------------------------
  // Analyze hair using CNN model
  Future<void> _analyzeHair(String imagePath) async {
    try {
      final result = await _classifier.predictImage(imagePath);

      final hairType = result["hairType"] as String;
      final confidence = result["confidence"] as double;

      setState(() {
        _isAnalyzing = false; //Finishes analyzing
      });

      // Navigate to hair analysis results page OR error page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HairAnalysisResultsPage(
              hairType: hairType,
              confidence: confidence,
              imagePath: imagePath, // <-- PASS THE IMAGE
            ),
          ),
        );
      }
    } catch (e) {
      // CNN couldn't recognize the hair
      setState(() {
        _isAnalyzing = false;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ErrorPage(
              // Error page in case of unrecognized hair and CNN failure
            ),
          ),
        );
      }
    }
  }

  //----------------------------------------------------------------------------
  // Open camera and take picture function to be accessed when button is pressed
  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        setState(() {
          _isAnalyzing = true;
        });

        await _analyzeHair(photo.path);
      }
    } catch (e) {
      _showError('Could not access camera');
    }
  }

  //----------------------------------------------------------------------------
  // Open gallery and pick image function to be accessed when button is pressed
  Future<void> _openGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _isAnalyzing = true;
        });

        await _analyzeHair(photo.path);
      }
    } catch (e) {
      _showError('Could not access gallery');
    }
  }

  //----------------------------------------------------------------------------
  // Show error message
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  //----------------------------------------------------------------------------
  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image layer
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/photo-instructions-hair.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay layer
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.20),
            ),
          ),
          // Content layer
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Text(
                  'Photo\nInstructions',
                  style: AppTextStyles.h1.copyWith(color: AppColors.white),
                ),
              ),
              const Spacer(),
              // Instructions list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  spacing: 24,
                  children: [
                    _buildInstructionItem(
                      icon: Icons.crop_free,
                      text: 'Make sure that your hair is within the frame.',
                    ),
                    _buildInstructionItem(
                      icon: Icons.content_cut,
                      text: 'Your hair must not be styled.',
                    ),
                    _buildInstructionItem(
                      icon: Icons.wb_sunny_outlined,
                      text: 'Ensure that you are under good, natural lighting.',
                    ),
                    _buildInstructionItem(
                      icon: Icons.blur_off,
                      text: 'Your photo must not be blurry.',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Bottom buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 50,
                ),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: GradientButton(
                        backgroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        textStyle: AppTextStyles.s.copyWith(
                          color: AppColors.primary,
                        ),
                        text: 'Open camera',
                        onPressed: _isAnalyzing ? null : _openCamera,
                      ),
                    ),
                    Expanded(
                      child: GradientButton(
                        backgroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        textStyle: AppTextStyles.s.copyWith(
                          color: AppColors.primary,
                        ),
                        text: 'Upload photo',
                        onPressed: _isAnalyzing ? null : _openGallery,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Loading overlay when analyzing
          if (_isAnalyzing)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animation/AI Searching.json',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing your hair...',
                      style: AppTextStyles.m.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Instruction item widget
  Widget _buildInstructionItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Icon(icon, size: 24, color: AppColors.white),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.m.copyWith(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
