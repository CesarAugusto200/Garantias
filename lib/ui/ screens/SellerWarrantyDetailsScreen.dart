import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class SellerWarrantyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> warranty;

  const SellerWarrantyDetailsScreen({super.key, required this.warranty});

  @override
  Widget build(BuildContext context) {
    print("🔎 Datos de garantía recuperados: $warranty");

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Detalles de Garantía - Vendedor", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    _buildSectionTitle("📸 Foto de la Garantía"),
                    _buildWarrantyPhoto(),

                    SizedBox(height: 24),
                    _buildSectionTitle("📌 Información del Producto"),
                    _buildInfoCard(Icons.shopping_bag, "Producto", warranty['product'] ?? "No registrado"),
                    _buildInfoCard(Icons.store, "Tienda", warranty['store'] ?? "No disponible"),
                    _buildInfoCard(Icons.calendar_today, "Fecha de compra", _formatDate(warranty['purchaseDate'])),
                    _buildInfoCard(Icons.timelapse, "Expiración", _formatDate(warranty['expirationDate'])),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWarrantyPhoto() {
    if (warranty['photoUrl'] != null && warranty['photoUrl'].isNotEmpty) {
      File imageFile = File(warranty['photoUrl'].trim());

      print("🔎 Intentando cargar imagen desde: ${imageFile.path}");

      if (!imageFile.existsSync()) {
        print("❌ La imagen no existe en la ruta: ${imageFile.path}");
        return Text("⚠️ No se encontró la imagen en la ruta: ${imageFile.path}");
      }

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            imageFile,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Text("📸 No hay imagen disponible.");
    }
  }

  String _formatDate(dynamic date) {
    try {
      if (date is String) {
        DateTime parsedDate = DateTime.tryParse(date) ?? DateFormat("d 'de' MMMM 'de' yyyy").parse(date);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      }
    } catch (e) {
      print("❌ Error al convertir fecha: $date - $e");
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
