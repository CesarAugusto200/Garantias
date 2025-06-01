import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/warranty_viewmodel.dart';
import '../../data/models/warranty.dart';

class AddWarrantyScreen extends StatefulWidget {
  @override
  _AddWarrantyScreenState createState() => _AddWarrantyScreenState();
}

class _AddWarrantyScreenState extends State<AddWarrantyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _storeController = TextEditingController();
  DateTime? _purchaseDate;
  DateTime? _expirationDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Garantía')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _storeController,
                decoration: InputDecoration(labelText: 'Tienda'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _purchaseDate = picked);
                },
                child: Text(_purchaseDate == null
                    ? 'Seleccionar Fecha de Compra'
                    : 'Fecha de Compra: ${_purchaseDate!.toLocal()}'),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 365)), // 1 año por defecto
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _expirationDate = picked);
                },
                child: Text(_expirationDate == null
                    ? 'Seleccionar Fecha de Expiración'
                    : 'Expira el: ${_expirationDate!.toLocal()}'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _purchaseDate != null && _expirationDate != null) {
                    Provider.of<WarrantyViewModel>(context, listen: false).addWarranty(
                      Warranty(
                        productName: _productNameController.text,
                        store: _storeController.text,
                        purchaseDate: _purchaseDate!,
                        expirationDate: _expirationDate!,
                      ),
                      context, // <-- Pasando 'context' correctamente
                    );
                    Navigator.pop(context); // Regresar a la pantalla principal
                  }
                },
                child: Text('Guardar Garantía'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
