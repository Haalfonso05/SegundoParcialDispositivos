class ProductModel {
  final int id;
  final String title;
  final String slug;
  final int episodes;
  final int price;
  final String description;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.episodes,
    required this.price,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: (json['mal_id'] as num?)?.toInt() ?? 0,
        title: (json['title'] as String?)?.trim().isNotEmpty == true
            ? (json['title'] as String).trim()
            : 'not title',
        slug: (json['type'] as String?)?.trim().isNotEmpty == true
            ? (json['type'] as String).trim()
            : 'not slug',
        episodes: (json['episodes'] as num?)?.toInt() ?? 0,
        price: (((json['score'] as num?) ?? 0) * 10).round(),
        description: (json['synopsis'] as String?)?.trim().isNotEmpty == true
            ? _sanitizeDescription((json['synopsis'] as String).trim())
            : 'not description',
        image: _extractImage(json),
      );

  static String _sanitizeDescription(String raw) {
    final cleaned = raw
      .replaceAll(RegExp(r'\[\s*Written by MAL Rewrite\s*\]', caseSensitive: false), '')
      .replaceAll(RegExp(r'\(\s*Source:\s*MAL Rewrite\s*\)', caseSensitive: false), '')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();

    return cleaned.isEmpty ? 'not description' : cleaned;
  }

  static String _extractImage(Map<String, dynamic> json) {
    final images = json['images'];
    if (images is Map<String, dynamic>) {
      final jpg = images['jpg'];
      final webp = images['webp'];

      if (jpg is Map<String, dynamic>) {
        final image = (jpg['large_image_url'] as String?)?.trim() ??
            (jpg['image_url'] as String?)?.trim();
        if (image != null && image.isNotEmpty) return normalizeImageUrl(image);
      }

      if (webp is Map<String, dynamic>) {
        final image = (webp['large_image_url'] as String?)?.trim() ??
            (webp['image_url'] as String?)?.trim();
        if (image != null && image.isNotEmpty) return normalizeImageUrl(image);
      }
    }

    return '';
  }

  static String normalizeImageUrl(String image) {
    final uri = Uri.tryParse(image);
    if (uri == null) return image;

    if (uri.host == 'myanimelist.net') {
      return uri.replace(host: 'cdn.myanimelist.net').toString();
    }

    return image;
  }
}
