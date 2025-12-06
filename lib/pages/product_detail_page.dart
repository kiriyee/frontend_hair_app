import 'package:flutter/material.dart';
import 'package:pleasepleaseplease/pages/feedback_page.dart';
import '../default_styles/app_colors.dart';
import '../default_styles/app_text_styles.dart';
import 'package:pleasepleaseplease/widgets/gradient_button.dart';
import '../models/product_model.dart';
import '../widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'Product Details',
        backIconColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large product image
            InkWell(
              onTap: () => _openProductUrl(context),
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  InkWell(
                    onTap: () => _openProductUrl(context),
                    child: Text(
                      product.name,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textHeading,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceActionLight,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.xxs.copyWith(
                            color: AppColors.textActionDark,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // Description section
                  Text(
                    'Description',
                    style: AppTextStyles.h5.copyWith(color: AppColors.textBody),
                  ),
                  const SizedBox(height: 4),

                  // TODO: Replace with actual product description from NLP
                  Text(
                    'This product is specially formulated for your hair type. '
                    'It contains natural ingredients that help maintain healthy, '
                    'beautiful hair. Perfect for daily use and suitable for all hair types.',
                    style: AppTextStyles.s.copyWith(color: AppColors.textBody),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Rate Product button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: GradientButton(
          text: 'Rate Product',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FeedbackPage(
                  // PLACEHOLDER values for testing, para lang makita yung UI. replaced by the models in integration
                  productId: "123",
                  productName: "Herbal Shampoo",
                  hairType: "Curly",
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openProductUrl(BuildContext context) async {
    final url = product.shopUrl;
    
    if (url == null || url.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product link is not available'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        // Try platformDefault first (more reliable on Android)
        // Falls back to externalApplication if needed
        try {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } catch (e) {
          // If platformDefault fails, try externalApplication as fallback
          final errorMessage = e.toString().toLowerCase();
          if (errorMessage.contains('component name') || 
              errorMessage.contains('null')) {
            // Try externalApplication as fallback
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            rethrow;
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open product link'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        final errorMessage = e.toString().toLowerCase();
        String userMessage;
        if (errorMessage.contains('component name') || 
            errorMessage.contains('null')) {
          userMessage = 'No app available to open this link. Please install a web browser.';
        } else {
          userMessage = 'Error opening link: $e';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
