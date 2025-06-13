import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WarrantyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> warranty;

  const WarrantyDetailsScreen({super.key, required this.warranty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Detalles de Garantía", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("📌 Información del Producto"),
                  _buildInfoCard(Icons.shopping_bag, "Producto", warranty['product']),
                  _buildInfoCard(Icons.store, "Tienda", warranty['store']),
                  _buildInfoCard(Icons.calendar_today, "Fecha de compra", _formatDate(warranty['purchaseDate'])),
                  _buildInfoCard(Icons.timelapse, "Expiración", _formatDate(warranty['expirationDate'])),

                  SizedBox(height: 24),
                  _buildSectionTitle("👤 Cliente"),
                  _buildInfoCard(Icons.person, "Nombre", warranty['customerName'] ?? 'No disponible'),
                  _buildInfoCard(Icons.email, "Correo", warranty['customerEmail'] ?? 'Correo no registrado'),

                  SizedBox(height: 24),
                  _buildSectionTitle("👨‍💼 Vendedor"),
                  _buildInfoCard(Icons.business, "Nombre", warranty['sellerName'] ?? 'No disponible'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      return DateFormat('dd/MM/yyyy').format(date.toDate());
    }
    return "Fecha no disponible";
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              "$title: $value",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, top: 6),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}
