class SearchResultItem {
  final String title;
  final String? subtitle;
  final String? id;
  final String? imageBase64;
  final String? imageUrl;
  final void Function()? onTap;

  SearchResultItem({
    required this.title,
    this.subtitle,
    this.id,
    this.imageBase64,
    this.imageUrl,
    this.onTap,
  });
}
