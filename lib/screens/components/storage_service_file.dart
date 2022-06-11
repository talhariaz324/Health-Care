import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> uploadFile(String? filePath, String fileName) async {
    File file  = File(filePath!);

    try {
      await storage.ref('prescriptions/$userId/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
    print(e);
    }
  }
  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result = await storage.ref('prescriptions/$userId').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
     });
     return result;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl = await storage.ref('prescriptions/$userId/$imageName').getDownloadURL();
    return downloadUrl;
  }
}