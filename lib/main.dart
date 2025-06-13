import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:garantias/ui/%20screens/HomeScreen.dart';
import 'package:garantias/ui/%20screens/home_cliente_screen.dart';
import 'package:garantias/ui/%20screens/login_screen.dart';
import 'package:garantias/ui/%20screens/register_screen.dart';


import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'viewmodels/warranty_viewmodel.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => WarrantyViewModel()..loadWarranties(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/home_cliente': (context) => HomeClienteScreen(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
    );
  }
}
