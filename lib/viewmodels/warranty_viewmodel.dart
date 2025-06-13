import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/warranty.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WarrantyViewModel extends ChangeNotifier {
  List<Warranty> _warranties = [];
  List<Warranty> get warranties => _warranties;

  /// 🔹 Cargar garantías del CLIENTE
  Future<void> loadWarranties() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ Usuario no autenticado. No se pueden cargar garantías.");
      return;
    }

    print("🔄 Buscando garantías del cliente con userId: ${user.uid}");

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('warranties')
          .where('userId', isEqualTo: user.uid)
          .get();

      print("📝 Documentos encontrados: ${snapshot.docs.length}");

      _warranties = snapshot.docs.map((doc) {
        var data = doc.data()!;
        print("🔎 Datos de garantía recuperados: $data"); // 🔹 Depuración
        return Warranty(
          id: doc.id,
          productName: data.containsKey('product') ? data['product'] : "Sin nombre registrado",
          store: data['store'] ?? "Tienda desconocida",
          purchaseDate: _parseDate(data['purchaseDate']),
          expirationDate: _parseDate(data['expirationDate']),
          sellerId: data['sellerId'] ?? "Sin vendedor",
          userId: data['userId'] ?? "Usuario desconocido",
          sellerName: data['sellerName'] ?? "Sin nombre",
          customerName: data['customerName'] ?? "No disponible",
          customerEmail: data['customerEmail'] ?? "Correo no registrado",
        );
      }).toList();

      print("✅ Garantías del cliente cargadas correctamente.");
    } catch (e) {
      print("❌ Error al cargar garantías del cliente: $e");
    }

    notifyListeners();
  }

  ///  Cargar garantías emitidas por el VENDEDOR
  Future<void> loadSellerWarranties() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ Usuario no autenticado. No se pueden cargar garantías del vendedor.");
      return;
    }

    print("🔄 Buscando garantías con sellerId: ${user.uid}");

    try {
      final snapshot = await FirebaseFirestore.instance.collection('warranties')
          .where('sellerId', isEqualTo: user.uid)
          .get();

      print("📝 Documentos encontrados: ${snapshot.docs.length}");

      _warranties = snapshot.docs.map((doc) {
        var data = doc.data()!;
        print("🔎 Datos de garantía recuperados: $data"); // 🔹 Depuración
        return Warranty(
          id: doc.id,
          productName: data.containsKey('product') ? data['product'] : "Sin nombre registrado",
          store: data['store'] ?? "Tienda desconocida",
          purchaseDate: _parseDate(data['purchaseDate']),
          expirationDate: _parseDate(data['expirationDate']),
          sellerId: data['sellerId'] ?? "Vendedor desconocido",
          userId: data['userId'] ?? "Usuario desconocido",
          sellerName: data['sellerName'] ?? "Sin nombre",
          customerName: data['customerName'] ?? "No disponible",
          customerEmail: data['customerEmail'] ?? "Correo no registrado",
        );
      }).toList();

      print("✅ Garantías del vendedor cargadas correctamente.");
    } catch (e) {
      print("❌ Error al cargar garantías del vendedor: $e");
    }

    notifyListeners();
  }

  ///  Función  para convertir `Timestamp` o `DateTime` a `DateTime`
  DateTime _parseDate(dynamic date) {
    if (date == null) {
      print("⚠️ Fecha inválida, asignando fecha actual.");
      return DateTime.now();
    }
    if (date is Timestamp) return date.toDate();
    if (date is DateTime) return date;
    print("⚠️ Formato de fecha inesperado: $date. Se asigna fecha actual.");
    return DateTime.now();
  }
}
