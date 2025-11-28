class AppInstruction {
  final String title;
  final String description;
  final String? imagePath;

  AppInstruction({
    required this.title,
    required this.description,
    this.imagePath,
  });
}
