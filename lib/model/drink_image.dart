class DrinkImage {
  final String id;
  final String fileName;
  final String imageBase64;

  DrinkImage({
    required this.id,
    required this.fileName,
    required this.imageBase64,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fileName': fileName,
      'imageBase64': imageBase64,
    };
  }

  factory DrinkImage.fromMap(Map<String, dynamic> map) {
    return DrinkImage(
      id: map['id'] as String,
      fileName: map['fileName'] as String,
      imageBase64: map['imageBase64'] as String,
    );
  }
}
