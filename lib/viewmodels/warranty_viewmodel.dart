import 'package:flutter/material.dart';
import '../data/models/warranty.dart';
import '../data/repositories/WarrantyDatabase.dart';
import '../services/notification_service.dart';

class WarrantyViewModel extends ChangeNotifier {
  List<Warranty> _warranties = [];
  List<Warranty> get warranties => _warranties;

  Future<void> loadWarranties() async {
    _warranties = await WarrantyDatabase.instance.fetchAllWarranties();
    notifyListeners();
  }

  Future<void> addWarranty(Warranty warranty, BuildContext context) async { // <-- Agregando 'context' aquí
    await WarrantyDatabase.instance.insertWarranty(warranty);
    await loadWarranties();

    // Programar una notificación 7 días antes de la expiración
    DateTime reminderDate = warranty.expirationDate.subtract(Duration(days: 7));
    await NotificationService.scheduleNotification(
      warranty.id ?? 0,
      'Garantía por vencer',
      'Tu garantía de ${warranty.productName} vence pronto.',
      reminderDate,
      context, // <-- Pasando 'context' correctamente
    );

    notifyListeners();
  }
}
