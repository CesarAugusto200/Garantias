import 'package:flutter/material.dart';
import 'package:garantias/ui/%20screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/warranty_viewmodel.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Asegura inicialización antes de correr la app
  await NotificationService.init();  // Inicializar servicio de notificaciones

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
      title: 'Gestión de Garantías',
      home: HomeScreen(),
    );
  }
}
