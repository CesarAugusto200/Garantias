import 'package:cloud_firestore/cloud_firestore.dart';

class Warranty {
  String id;
  String productName;
  String store;
  DateTime purchaseDate;
  DateTime expirationDate;
  String userId;
  String sellerId;
  String sellerName;
  String customerName;
  String customerEmail;

  Warranty({
    required this.id,
    required this.productName,
    required this.store,
    required this.purchaseDate,
    required this.expirationDate,
    required this.userId,
    required this.sellerId,
    required this.sellerName,
    required this.customerName,
    required this.customerEmail,
  });

  ///  Clonar con modificaciones
  Warranty copyWith({
    String? id,
    String? productName,
    String? store,
    DateTime? purchaseDate,
    DateTime? expirationDate,
    String? userId,
    String? sellerId,
    String? sellerName,
    String? customerName,
    String? customerEmail,
  }) {
    return Warranty(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      store: store ?? this.store,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expirationDate: expirationDate ?? this.expirationDate,
      userId: userId ?? this.userId,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
    );
  }

  ///  Convertir el objeto a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'store': store,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'expirationDate': Timestamp.fromDate(expirationDate),
      'userId': userId,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'customerName': customerName,
      'customerEmail': customerEmail,
    };
  }


  factory Warranty.fromMap(Map<String, dynamic> map) {
    return Warranty(
      id: (map['id'] ?? '').toString(),
      productName: map['productName'] ?? 'Producto desconocido',
      store: map['store'] ?? 'Tienda desconocida',
      purchaseDate: _parseDate(map['purchaseDate']),
      expirationDate: _parseDate(map['expirationDate']),
      userId: map['userId'] ?? 'Usuario desconocido',
      sellerId: map['sellerId'] ?? 'Vendedor desconocido',
      sellerName: map['sellerName'] ?? 'Nombre desconocido',
      customerName: (map['customerName'] ?? 'No disponible').toString(),
      customerEmail: (map['customerEmail'] ?? 'Correo no registrado').toString(),
    );
  }

  /// Función para convertir `Timestamp` o `DateTime` a `DateTime`
  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is Timestamp) return date.toDate();
    if (date is DateTime) return date;
    return DateTime.now();
  }
}
