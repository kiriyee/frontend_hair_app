import 'package:flutter/material.dart';
import '../default_styles/app_text_styles.dart';
import '../default_styles/app_colors.dart';
import '../models/placeholder_nlp_model.dart';
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

  // TODO: Replace with actual data from the NLP algorithm
  // just a PLACEHOLDER, will be automated once it is replaced. we just need it para makita yung UI
  final Map<String, List<Product>> _productsByCategory = {
    'Shampoo': [
      Product(
        id: '1',
        name: 'Moisturizing Shampoo',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Moisturizing', 'Sulfate-Free'],
      ),
      Product(
        id: '2',
        name: 'Strengthening Shampoo',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Strengthening', 'Keratin'],
      ),
      Product(
        id: '3',
        name: 'Volume Boost Shampoo',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Volume', 'Lightweight'],
      ),
      Product(
        id: '4',
        name: 'Color Safe Shampoo',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Color Safe', 'UV Protection'],
      ),
    ],
    'Hair Conditioner': [
      Product(
        id: '5',
        name: 'Deep Conditioning Treatment',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Deep Moisture', 'Repair'],
      ),
      Product(
        id: '6',
        name: 'Leave-In Conditioner',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Leave-In', 'Detangling'],
      ),
      Product(
        id: '7',
        name: 'Smoothing Conditioner',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Smoothing', 'Anti-Frizz'],
      ),
      Product(
        id: '8',
        name: 'Volumizing Conditioner',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Volume', 'Lightweight'],
      ),
    ],
    'Styling Product': [
      Product(
        id: '9',
        name: 'Hair Serum',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Shine', 'Anti-Frizz'],
      ),
      Product(
        id: '10',
        name: 'Styling Gel',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Strong Hold', 'Non-Sticky'],
      ),
      Product(
        id: '11',
        name: 'Hair Spray',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Flexible Hold', 'Natural'],
      ),
      Product(
        id: '12',
        name: 'Styling Cream',
        imageUrl: 'https://via.placeholder.com/164x195',
        tags: ['Definition', 'Moisturizing'],
      ),
    ],
  };

  // navigation bar controller
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  // disposes the tab controller widget when not in use to free up resources
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // gives value to the selected category based on the selected tab index
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
        child: Column(
          children: [
            // Hair type banner with image
            _buildHairTypeBanner(),

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
    // Get the appropriate image based on hair type
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
                  fit: BoxFit
                      .cover, // cover the entire area, auto crop if needed
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.2),
                ), // dark overlay
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  '${widget.hairType} hair', // text showing hair type on the banner
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

  // Product grid (scrollable, 2 columns, flexible number of products per row in each category)
  Widget _buildProductGrid() {
    final products = _productsByCategory[_selectedCategory] ?? [];

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
        // Navigate to product detail page
        _openProductDetail(product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
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
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: product.tags.map((tag) {
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
