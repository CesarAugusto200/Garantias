class Warranty {
  int? id;
  String productName;
  String store;
  DateTime purchaseDate;
  DateTime expirationDate;

  Warranty({
    this.id,
    required this.productName,
    required this.store,
    required this.purchaseDate,
    required this.expirationDate,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'store': store,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
    };
  }


  factory Warranty.fromMap(Map<String, dynamic> map) {
    return Warranty(
      id: map['id'],
      productName: map['productName'],
      store: map['store'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      expirationDate: DateTime.parse(map['expirationDate']),
    );
  }
}
