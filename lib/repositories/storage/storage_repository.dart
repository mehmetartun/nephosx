import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: "gs://nephosx-dev.firebasestorage.app",
  );

  Future<String?> uploadFile({
    required String path,
    required PlatformFile file,
  }) async {
    print("Bucket: ${_storage.bucket}");
    try {
      final extension = p.extension(file.name);
      var name = p.basenameWithoutExtension(file.name);
      name += " ${DateTime.timestamp().toIso8601String()}";
      final ref = _storage.ref().child(path).child(name + extension);
      UploadTask uploadTask;

      if (file.bytes != null) {
        // Web or when bytes are available
        uploadTask = ref.putData(file.bytes!);
      } else {
        // Mobile/Desktop when path is available
        uploadTask = ref.putFile(File(file.path!));
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<PlatformFile?> pickFile() async {
    print("Bucket: ${_storage.bucket}");
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    return result?.files.single;
  }

  Future<String> getDownloadURL(String path) async {
    return await _storage.ref(path).getDownloadURL();
  }
}
