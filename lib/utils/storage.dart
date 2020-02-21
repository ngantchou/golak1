import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  Future<String> pickImage() async {
    String filePath;
    filePath = await FilePicker.getFilePath(type: FileType.IMAGE);
    return filePath;
  }

  Future<String> uploadImage({
    extension,
    filePath,
    type,
  }) async {
    final String fileName = Random().nextInt(10000).toString() + '.$extension';
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: type + '/' + extension,
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }
}
