import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> uploadFile(String? filePath1, String? filePath2, String fileName,
      String fileName2) async {
    File file1 = File(filePath1!);
    File file2 = File(filePath2!);

    try {
      await storage.ref('prescriptions/$userId/$fileName').putFile(file1);
      await storage.ref('prescriptions/$userId/$fileName2').putFile(file2);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result =
        await storage.ref('prescriptions/$userId').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return result;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('prescriptions/$userId/$imageName').getDownloadURL();
    return downloadUrl;
  }
}
