
import 'package:convo/firebase_options.dart';
import 'package:convo/pages/home_page.dart';
import 'package:convo/pages/login_page.dart';
import 'package:convo/pages/register_page.dart';
import 'package:convo/pages/splash_page.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/services/cloud_storage_service.dart';
import 'package:convo/services/database_service.dart';
import 'package:convo/services/media_service.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';


void main()async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  // GetIt.instance.registerSingleton<MediaService>(MediaService());
  // GetIt.instance
  //     .registerSingleton<CloudStorageService>(CloudStorageService());
  // GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  runApp(SplashPage(
      key: UniqueKey(), 
      onInitializationComplete: (){
        runApp(MainApp());
      }
  ));
  //runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>(create:(BuildContext context){
            return AuthenticationProvider();
          })
        ],
      child: MaterialApp(
        title: "Convo",
        theme: ThemeData(
            backgroundColor: Color.fromARGB(255, 36, 35, 49),
            scaffoldBackgroundColor:  Color.fromARGB(255, 36, 35, 49),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color.fromARGB(255, 30, 29, 37))
        ),
        navigatorKey: NavigationService.navigatorKey,
        routes: {
          '/login':(BuildContext context)=>LoginPage(),
          '/register':(BuildContext context)=>RegisterPage(),
          '/home' :(BuildContext context)=>HomePage(),
        },
        initialRoute: '/login',
      ),
    );
  }
}

