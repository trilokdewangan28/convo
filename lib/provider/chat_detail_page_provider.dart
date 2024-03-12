import 'dart:async';

import 'package:convo/models/chat_message.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/services/cloud_storage_service.dart';
import 'package:convo/services/database_service.dart';
import 'package:convo/services/media_service.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatDetailPageProvider extends ChangeNotifier{
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;
  
  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;
  
  String _chatId;
  List<ChatMessage>? messages;
  
  String? _message;
  String get messagge{
    return _message!;
  }
  
  ChatDetailPageProvider(this._chatId, this._auth, this._messagesListViewController){
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  void goBack(){
    _navigation.goBack();
  }
  
}