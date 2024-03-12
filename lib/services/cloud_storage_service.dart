import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "User";

class CloudStorageService{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CloudStorageService(){}
  
  Future<String?> saveUserImageToStorage(String _uid, PlatformFile _file)async{
    try{
      String storagePath = 'images/users/$_uid/profile.${_file.extension}';
      Reference _ref = _storage.ref().child(storagePath);
      UploadTask _task = _ref.putFile(File(_file.path!));
      return await _task.then((_result) => _result.ref.getDownloadURL());
    }catch(e){
      print('something went wron while imge uploading on storage $e');
    }
  }
  
  Future<String?> saveChatImageToStorage(String _chatID, String _userID, PlatformFile _file)async{
    try{
      String storagePath = 'images/chats/$_chatID/${_userID}_${Timestamp.now().millisecondsSinceEpoch}.${_file.extension}';
      Reference _ref = _storage.ref().child(storagePath);
      UploadTask _task = _ref.putFile(File(_file.path!));
      return await _task.then((_result) => _result.ref.getDownloadURL());
    }catch(e){
      print('something went wrong while saving chat image on storage $e');
    }
  }
  
}