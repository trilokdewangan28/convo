import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/chat_message.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set({
        "email": _email,
        "name": _name,
        "image": _imageURL,
        "last_active": DateTime.now().toUtc()
      });
    } catch (e) {
      print('something went wrong while registering the user $e');
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) async {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db
          .collection(USER_COLLECTION)
          .doc(_uid)
          .update({"last_active": DateTime.now().toUtc()});
    } catch (e) {
      print('error updating user: $e');
    }
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessageForChat(String _chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> deleteChat(String _chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMessageToChat(String _chatId, ChatMessage _message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGES_COLLECTION)
          .add(_message.toJson());
    } catch (e) {
      print(e);
    }
  }
  
  Future<void> updateChatData(String _chatId, Map<String,dynamic> _data)async{
    try{
      await _db.collection(CHAT_COLLECTION).doc(_chatId).update(_data);
    }catch(e){
      print(e);
    }
  }
  
  
}
