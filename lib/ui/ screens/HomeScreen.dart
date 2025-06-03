import 'package:flutter/material.dart';
import 'package:garantias/ui/%20screens/warranty_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/warranty_viewmodel.dart';
import '../widgets/warranty_card.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    var warrantyVM = Provider.of<WarrantyViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Gestión de Garantías',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blueAccent, size: 28),
            ),
            onSelected: (value) {
              if (value == "logout") _logout(context);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "logout", child: Text("Cerrar sesión")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<WarrantyViewModel>(
          builder: (context, warrantyVM, child) {
            if (warrantyVM.warranties.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_rounded, color: Colors.grey[500], size: 60),
                    SizedBox(height: 12),
                    Text(
                      "No hay garantías registradas",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: warrantyVM.warranties.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: WarrantyCard(warranty: warrantyVM.warranties[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddWarrantyScreen()),
          );
        },
        child: Icon(Icons.add_circle_outline, size: 32, color: Colors.white),
      ),
    );
  }
}
