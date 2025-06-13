import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ screens/SellerWarrantyDetailsScreen.dart';
import '../ screens/WarrantyDetailsScreen.dart';
import '../../data/models/warranty.dart';

class WarrantyCard extends StatelessWidget {
  final Warranty warranty;
  final bool isSellerView;

  WarrantyCard({required this.warranty, required this.isSellerView});

  @override
  Widget build(BuildContext context) {
    DateTime expirationDate = warranty.expirationDate;

    return Card(
      child: ListTile(
        title: Text(warranty.productName),
        subtitle: Text(
          'Garantía hasta: ${DateFormat("d 'de' MMMM 'de' yyyy").format(expirationDate)}',
        ),
        trailing: Icon(Icons.info_outline),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => isSellerView
                  ? SellerWarrantyDetailsScreen(
                warranty: {
                  'product': warranty.productName,
                  'store': warranty.store,
                  'purchaseDate': warranty.purchaseDate,
                  'expirationDate': warranty.expirationDate,
                  'sellerName': warranty.sellerName,
                  'customerName': warranty.customerName ?? "No disponible", // 🔹 Corrección
                  'customerEmail': warranty.customerEmail ?? "Correo no registrado", // 🔹 Corrección
                },
              )
                  : WarrantyDetailsScreen(
                warranty: {
                  'product': warranty.productName,
                  'store': warranty.store,
                  'purchaseDate': warranty.purchaseDate,
                  'expirationDate': warranty.expirationDate,
                  'sellerName': warranty.sellerName,
                  'customerName': warranty.customerName ?? "No disponible", // 🔹 Corrección
                  'customerEmail': warranty.customerEmail ?? "Correo no registrado", // 🔹 Corrección
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
