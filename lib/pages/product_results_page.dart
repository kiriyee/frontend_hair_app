import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../default_styles/app_text_styles.dart';
import '../default_styles/app_colors.dart';
import '../models/product_model.dart';
import 'product_detail_page.dart';
import 'package:pleasepleaseplease/widgets/appbar.dart';

class ProductResultsPage extends StatefulWidget {
  final String hairType;
  final double confidence;

  const ProductResultsPage({
    super.key,
    required this.hairType,
    required this.confidence,
  });

  @override
  State<ProductResultsPage> createState() => _ProductResultsPageState();
}

class _ProductResultsPageState extends State<ProductResultsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // API State Variables
  bool _isLoading = true;
  String? _errorMessage;
  String _explanation = "";

  // Stores fetched products sorted by category
  Map<String, List<Product>> _productsByCategory = {
    'Shampoo': [],
    'Hair Conditioner': [],
    'Styling Product': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    // Fetch data from Python backend on startup
    _fetchRecommendations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- API FETCHING LOGIC ---
  Future<void> _fetchRecommendations() async {
    // Use Android emulator IP to talk to Flask running on host machine
    final url = Uri.parse('https://axyDev.pythonanywhere.com/recommend');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "hair_type": widget.hairType,
          "confidence": widget.confidence,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          setState(() {
            _errorMessage = "Unexpected response format from server.";
            _isLoading = false;
          });
          return;
        }

        final data = decoded;

        // 1. Parse products from JSON (defensive)
        final recsDynamic = data['recommendations'];
        List<dynamic> recsList;
        if (recsDynamic is List) {
          recsList = recsDynamic;
        } else {
          recsList = const [];
        }

        List<Product> products = recsList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        // 2. Sort into categories used by UI
        Map<String, List<Product>> sorted = {
          'Shampoo': [],
          'Hair Conditioner': [],
          'Styling Product': [],
        };

        for (var p in products) {
          String cat = p.category.toLowerCase();
          if (cat.contains('shampoo')) {
            sorted['Shampoo']!.add(p);
          } else if (cat.contains('conditioner')) {
            sorted['Hair Conditioner']!.add(p);
          } else {
            // Default bucket if it doesn't match others
            sorted['Styling Product']!.add(p);
          }
        }

        setState(() {
          _productsByCategory = sorted;
          _explanation = (data['explanation'] ?? '').toString();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Server Error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            "Connection Error.\nCheck if Python is running on port 5000 and that you're using the correct IP.\nDetails: $e";
        _isLoading = false;
      });
    }
  }

  // Helper to get current category string based on tab
  String get _selectedCategory {
    switch (_selectedTabIndex) {
      case 0:
        return 'Shampoo';
      case 1:
        return 'Hair Conditioner';
      case 2:
        return 'Styling Product';
      default:
        return 'Shampoo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'Product Recommendations',
        backIconColor: Colors.black,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Hair type banner with image
                      _buildHairTypeBanner(),

                      // Optional: Explanation Text from NLP
                      if (_explanation.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _explanation,
                              style: AppTextStyles.s,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                      // Category tabs
                      _buildCategoryTabs(),

                      // Product grid (scrollable)
                      Expanded(child: _buildProductGrid()),
                    ],
                  ),
      ),
    );
  }

  // Hair type banner with image overlay
  Widget _buildHairTypeBanner() {
    String getBannerImage() {
      switch (widget.hairType.toLowerCase()) {
        case 'straight':
          return 'assets/images/hair_straight.jpg';
        case 'wavy':
          return 'assets/images/hair_wavy.jpg';
        case 'curly':
          return 'assets/images/hair_curly.jpg';
        default:
          return 'assets/images/hair_straight.jpg'; // fallback
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 328 / 149,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  getBannerImage(),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Updated from withValues
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  '${widget.hairType} hair',
                  style: AppTextStyles.h4.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Category tabs (Shampoo, Conditioner, Styling Product)
  Widget _buildCategoryTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderDefault, width: 0.5),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.textBody,
        unselectedLabelColor: AppColors.textPlaceholder,
        indicatorColor: AppColors.primary,
        labelStyle: AppTextStyles.sBold,
        unselectedLabelStyle: AppTextStyles.xs,
        tabs: const [
          Tab(text: 'Shampoo'),
          Tab(text: 'Hair Conditioner'),
          Tab(text: 'Styling Product'),
        ],
      ),
    );
  }

  // PRODUCT GRID
  Widget _buildProductGrid() {
    final products = _productsByCategory[_selectedCategory] ?? [];

    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No recommendations found for this category."),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  // Individual product card
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        _openProductDetail(product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Updated from withValues
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    // Use NetworkImage for URLs from API
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Fallback if image fails to load
                    },
                  ),
                ),
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    style: AppTextStyles.mBold.copyWith(
                      color: AppColors.textBody,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Tags
                  if (product.tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: product.tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceActionLight,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: AppColors.surfaceActionLight,
                            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Open product detail page
  void _openProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }
}