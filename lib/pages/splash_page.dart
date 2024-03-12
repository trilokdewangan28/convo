import 'package:convo/firebase_options.dart';
import 'package:convo/services/cloud_storage_service.dart';
import 'package:convo/services/database_service.dart';
import 'package:convo/services/media_service.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({required Key key, required this.onInitializationComplete})
      : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      _setup().then((_) => widget.onInitializationComplete());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convo',
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 36, 35, 49),
        scaffoldBackgroundColor: Color.fromARGB(255, 36, 35, 49),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/logo.png'))),
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    print('firebase setup called........................');
    try{
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }catch(e){
      print('error while initializing firebase core $e');
    }
    print('firebase app initialized');
   _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }
}
