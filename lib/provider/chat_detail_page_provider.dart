import 'dart:async';

import 'package:convo/models/chat_message.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/services/cloud_storage_service.dart';
import 'package:convo/services/database_service.dart';
import 'package:convo/services/media_service.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

class ChatDetailPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message {
    return _message!;
  }

  void set message(String _msg) {
    _message = _msg;
  }

  ChatDetailPageProvider(
      this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessageForChat(_chatId).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          // Add Scroll to bottom call
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_messagesListViewController.hasClients) {
                _messagesListViewController.jumpTo(
                    _messagesListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print('error getting message');
      print(e);
    }
  }
  
  void listenToKeyboardChanges(){
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(_chatId, {"is_activity":_event});
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
          content: _message!,
          type: MessageType.TEXT,
          senderID: _auth.user.uid,
          sentTime: DateTime.now());
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL = await _storage.saveChatImageToStorage(
            _chatId, _auth.user.uid, _file);
        ChatMessage _messageToSend = ChatMessage(
            content: _downloadURL!,
            type: MessageType.IMAGE,
            senderID: _auth.user.uid,
            sentTime: DateTime.now());
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print('error sending image message');
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
