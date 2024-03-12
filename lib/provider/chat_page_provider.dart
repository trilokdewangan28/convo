import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/chat.dart';
import 'package:convo/models/chat_message.dart';
import 'package:convo/models/chat_user.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _db;
  List<Chat>? chats;
  late StreamSubscription _chatStream;

  ChatPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatStream =
          _db.getChatsForUser(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(_snapshot.docs.map((_d) async {
          Map<String, dynamic> _chatData = _d.data() as Map<String, dynamic>;
          // return Chat instance
          
          //GET MEMBER IN CHAT
          List<ChatUser> _members = [];
          for(var _uid in _chatData["members"]){
            DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
            Map<String,dynamic> _userData = _userSnapshot.data() as Map<String,dynamic>;
            _userData["uid"] = _userSnapshot.id;
            _members.add(ChatUser.fromJSON(_userData));
          }
          
          //GET MESSAGE IN CHAT
          List<ChatMessage> _messages = [];
          QuerySnapshot _chatMessage = await _db.getLastMessageForChat(_d.id);
          if(_chatMessage.docs.isNotEmpty){
            Map<String,dynamic> _messageData = _chatMessage.docs.first.data()! as Map<String,dynamic>;
            ChatMessage _message = ChatMessage.fromJSON(_messageData);
            _messages.add(_message);
          }
          return Chat(
            uid: _d.id,
            currentUserUid: _auth.user.uid,
            members: _members,
            messages: _messages,
            activity: _chatData['is_activity'],
            group: _chatData['is_group'],
          );
        }
        ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print('error getting chat $e');
    }
  }
}
