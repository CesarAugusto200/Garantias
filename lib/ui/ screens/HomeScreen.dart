import 'package:flutter/material.dart';
import 'package:garantias/ui/%20screens/warranty_screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/warranty_viewmodel.dart';
import '../widgets/warranty_card.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var warrantyVM = Provider.of<WarrantyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Garantías'),
      ),
      body: Consumer<WarrantyViewModel>(
        builder: (context, warrantyVM, child) {
          if (warrantyVM.warranties.isEmpty) {
            return Center(child: Text("No hay garantías registradas"));
          }

          return ListView.builder(
            itemCount: warrantyVM.warranties.length,
            itemBuilder: (context, index) {
              return WarrantyCard(warranty: warrantyVM.warranties[index]);
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddWarrantyScreen())
          );
        },
        child: Icon(Icons.add),
      ),

    );
  }
}
