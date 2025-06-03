import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importación necesaria para formato de fecha local

class AddWarrantyScreen extends StatefulWidget {
  @override
  _AddWarrantyScreenState createState() => _AddWarrantyScreenState();
}

class _AddWarrantyScreenState extends State<AddWarrantyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _storeController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _customerNameController = TextEditingController();
  DateTime? _purchaseDate;
  DateTime? _expirationDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text('Agregar Garantía', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF005AC1),
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 10,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTitle("Información del Producto"),
                    SizedBox(height: 20),
                    _buildTextField(_productNameController, "Nombre del Producto", Icons.shopping_bag_outlined),
                    SizedBox(height: 16),
                    _buildTextField(_storeController, "Tienda", Icons.store_mall_directory_outlined),
                    SizedBox(height: 16),
                    _buildTextField(_customerNameController, "Nombre del Cliente", Icons.person),
                    SizedBox(height: 16),
                    _buildTextField(_customerEmailController, "Correo del Cliente", Icons.alternate_email),
                    SizedBox(height: 16),
                    _buildTextField(_sellerNameController, "Nombre del Vendedor", Icons.badge),
                    SizedBox(height: 30),
                    _buildTitle("Fechas"),
                    SizedBox(height: 15),
                    _buildDateButton("Fecha de Compra", _purchaseDate, (picked) {
                      setState(() => _purchaseDate = picked);
                    }),
                    SizedBox(height: 16),
                    _buildDateButton("Fecha de Expiración", _expirationDate, (picked) {
                      setState(() => _expirationDate = picked);
                    }),
                    SizedBox(height: 35),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF005AC1),
                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      icon: Icon(Icons.check_circle_outline, color: Colors.white),
                      onPressed: _saveWarranty,
                      label: Text("Guardar Garantía", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: Color(0xFF005AC1)),
        filled: true,
        fillColor: Color(0xFFF4F7FB),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
    );
  }

  Widget _buildDateButton(String label, DateTime? date, Function(DateTime) onDateSelected) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF005AC1),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 3,
        ),
        icon: Icon(Icons.calendar_today_outlined, color: Colors.white),
        onPressed: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            locale: const Locale('es', 'ES'), // Asegura selector de fecha en español
          );
          if (picked != null) onDateSelected(picked);
        },
        label: Text(
          date == null
              ? label
              : "$label: ${DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_ES').format(date)}",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _saveWarranty() async {
    String product = _productNameController.text.trim();
    String store = _storeController.text.trim();
    String customerEmail = _customerEmailController.text.trim();
    String customerName = _customerNameController.text.trim();
    String sellerName = _sellerNameController.text.trim();

    if (product.isNotEmpty &&
        store.isNotEmpty &&
        customerEmail.isNotEmpty &&
        customerName.isNotEmpty &&
        sellerName.isNotEmpty &&
        _purchaseDate != null &&
        _expirationDate != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: customerEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String customerId = querySnapshot.docs.first.id;

          DocumentReference newWarrantyRef = await FirebaseFirestore.instance
              .collection('users')
              .doc(customerId)
              .collection('warranties')
              .add({
            'product': product,
            'store': store,
            'customerName': customerName,
            'sellerName': sellerName,
            'purchaseDate': Timestamp.fromDate(_purchaseDate!),
            'expirationDate': Timestamp.fromDate(_expirationDate!),
            'message': "Gracias por su compra, esta es su garantía.",
          });

          await newWarrantyRef.update({'id': newWarrantyRef.id});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Garantía asignada exitosamente")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No se encontró al cliente")),
          );
        }
      } catch (e) {
        print("❌ Error al asignar garantía: $e");
      }
    } else {
      print("❌ Campos vacíos");
    }
  }
}
