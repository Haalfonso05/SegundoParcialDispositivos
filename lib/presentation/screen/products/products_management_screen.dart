import 'package:flutter/material.dart';

import '../../../config/app_notifiers.dart';
import '../../../config/app_translations.dart';
import '../../../model/product_model.dart';
import '../../../service/product_service.dart';
import '../../widgets/layout/drawer_widget.dart';

class ProductsManagementScreen extends StatefulWidget {
  const ProductsManagementScreen({super.key});

  @override
  State<ProductsManagementScreen> createState() =>
      _ProductsManagementScreenState();
}

class _ProductsManagementScreenState extends State<ProductsManagementScreen> {
  int _selectedIndex = 0;

  // Form
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _episodesController = TextEditingController();
  final _scoreController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _imageController = TextEditingController();

  // Consultar
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    localeNotifier.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    localeNotifier.removeListener(_refresh);
    _titleController.dispose();
    _typeController.dispose();
    _episodesController.dispose();
    _scoreController.dispose();
    _synopsisController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final list = await ProductService().getProduct();
      setState(() {
        _products = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(tr('title_products')),
      ),
      drawer: const DrawerWidget(),
      body: _selectedIndex == 0 ? _buildForm() : _buildList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.add),
            label: tr('nav_add'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: tr('nav_view'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          _formField(_titleController, tr('field_title')),
          _formField(_typeController, tr('field_type')),
          _formField(_episodesController, tr('field_episodes'),
              keyboardType: TextInputType.number),
          _formField(_scoreController, tr('field_score'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          _formField(_synopsisController, tr('field_synopsis'), maxLines: 3),
          _formField(_imageController, tr('field_image')),
          const SizedBox(height: 32),
          SizedBox(
            width: 180,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1E3A8A),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: const BorderSide(color: Color(0xFFBBDEFB)),
                ),
              ),
              onPressed: _onSubmit,
              child: Text(tr('submit')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final resolvedKeyboardType = keyboardType ??
        (maxLines > 1 ? TextInputType.multiline : TextInputType.text);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: resolvedKeyboardType,
        textInputAction:
            maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('title_required'))),
      );
      return;
    }

    final score = double.tryParse(_scoreController.text.trim()) ?? 0.0;

    final newProduct = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      slug: _typeController.text.trim().isEmpty
          ? tr('no_type')
          : _typeController.text.trim(),
      episodes: int.tryParse(_episodesController.text.trim()) ?? 0,
      price: (score * 10).round(),
      description: _synopsisController.text.trim().isEmpty
          ? tr('no_desc')
          : _synopsisController.text.trim(),
      image: ProductModel.normalizeImageUrl(_imageController.text.trim()),
    );

    setState(() {
      _products.insert(0, newProduct);
      _selectedIndex = 1;
    });

    _titleController.clear();
    _typeController.clear();
    _episodesController.clear();
    _scoreController.clear();
    _synopsisController.clear();
    _imageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr('added_ok'))),
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Error: $_error', textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadProducts,
              child: Text(tr('retry')),
            ),
          ],
        ),
      );
    }
    if (_products.isEmpty) {
      return Center(child: Text(tr('no_products')));
    }
    return Builder(
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        final subtitleColor = cs.onSurface.withValues(alpha: 0.55);
        final chevronColor = cs.onSurface.withValues(alpha: 0.35);
        final imagePlaceholderColor = cs.onSurface.withValues(alpha: 0.08);

        return ListView.separated(
          itemCount: _products.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: cs.onSurface.withValues(alpha: 0.1),
          ),
          itemBuilder: (context, index) {
            final p = _products[index];
            return InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _ProductDetailView(product: p),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: p.image.isNotEmpty
                            ? Image.network(
                                p.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => ColoredBox(
                                  color: imagePlaceholderColor,
                                  child: Icon(Icons.broken_image_outlined,
                                      color: subtitleColor),
                                ),
                              )
                            : ColoredBox(
                                color: imagePlaceholderColor,
                                child: Icon(Icons.image_not_supported,
                                    color: subtitleColor),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: chevronColor),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final score = (product.price / 10).toStringAsFixed(1);
    final episodesLabel = product.episodes > 0
        ? '${product.episodes} episodios'
        : 'Episodios N/A';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: product.image.isNotEmpty
                      ? Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image_outlined,
                                size: 52),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported,
                              size: 52),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                product.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Puntaje: $score',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip('Tipo: ${product.slug}', Colors.blueGrey),
                  _chip(episodesLabel, Colors.teal),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Volver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(label),
    );
  }
}
