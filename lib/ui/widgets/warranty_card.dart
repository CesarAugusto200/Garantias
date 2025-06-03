import 'package:flutter/material.dart';
import '../../data/models/warranty.dart';

class WarrantyCard extends StatelessWidget {
  final Warranty warranty;

  WarrantyCard({required this.warranty});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(warranty.productName),
        subtitle: Text(
          'Garantía hasta: ${warranty.expirationDate.toLocal()}',
        ),
        trailing: Icon(Icons.info_outline),
        onTap: () {

        },
      ),
    );
  }
}
