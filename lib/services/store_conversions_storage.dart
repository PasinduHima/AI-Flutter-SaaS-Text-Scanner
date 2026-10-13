import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoreConversionsStorage {
  //Firebase storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({required File postImage, required String userId}) async {
    //Create a reference to the image, here the image will be stored in the conversions folder in the storage
    Reference ref =
        _storage.ref().child("conversions").child("$userId/${DateTime.now()}");

    try {
      UploadTask task = ref.putFile(
        postImage,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
}