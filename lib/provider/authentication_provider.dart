//packages
import 'package:convo/models/chat_user.dart';

//services
import 'package:convo/services/database_service.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;
  
  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        print('logged In');
        _databaseService.updateUserLastSeenTime(_user.uid);
        _databaseService.getUser(_user.uid).then((_snapshot) {
          Map<String, dynamic> _userData =
              _snapshot.data()! as Map<String, dynamic>;
          user = ChatUser.fromJSON({
            "uid": _user.uid,
            "name": _userData["name"],
            "email": _userData['email'],
            "last_active": _userData['last_active'],
            "image": _userData['image'],
          });
          print('user is : ${user.toMap()}');
          _navigationService.removeAndNavigateToRoute('/home');
        });
      } else {
        print('Not Authenticated');
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
    } on FirebaseAuthException {
      print('Error loging user to firebase');
    } catch (e) {
      print('firebase login error $e');
    }
  }
  
  Future<String?> registerUserUsingEmailAndPassword(String _email, String _password)async{
    try{
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
      return _credentials.user!.uid;
    } on FirebaseAuthException{
      print('error registering user');
    }
    catch(e){
      print('something went wrong $e');
    }
  } 
  
  Future<void> logout()async{
    try{
      await _auth.signOut();
    }catch(e){
      print('something went wrong while logout $e');
    }
  }
  
  
}
