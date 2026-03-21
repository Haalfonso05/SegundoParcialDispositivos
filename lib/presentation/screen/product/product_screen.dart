import 'package:flutter/material.dart';

import '../../../model/product_model.dart';
import '../../../service/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel> products = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void getProduct() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      final List<ProductModel> temporal = await ProductService().getProduct();

      setState(() {
        products = temporal;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Error: $error',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getProduct,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return const Center(child: Text('No hay productos'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final score = (product.price / 10).toStringAsFixed(1);
        final episodesLabel = product.episodes > 0
            ? '${product.episodes} episodios'
            : 'Episodios N/A';
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => _ProductDetailView(product: product),
              ),
            );
          },
          leading: SizedBox(
            width: 42,
            height: 42,
            child: ClipOval(
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
          ),
          title: Text(product.title),
          subtitle: Text('${product.slug} • $episodesLabel'),
          trailing: Text('⭐ $score'),
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
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_outlined, size: 52),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported, size: 52),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withAlpha(22),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.blueGrey.withAlpha(60)),
                    ),
                    child: Text('Tipo: ${product.slug}'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.teal.withAlpha(18),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.teal.withAlpha(60)),
                    ),
                    child: Text(episodesLabel),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Volver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
