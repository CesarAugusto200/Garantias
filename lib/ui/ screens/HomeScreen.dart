import 'package:flutter/material.dart';
import 'package:garantias/ui/%20screens/warranty_screen.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/warranty_viewmodel.dart';
import '../widgets/warranty_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Provider.of<WarrantyViewModel>(context, listen: false).loadSellerWarranties();
      }
    });
  }

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
        title: Text("Gestión de Garantías", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
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
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      Provider.of<WarrantyViewModel>(context, listen: false).loadSellerWarranties();
                    }
                  },
                  icon: Icon(Icons.refresh),
                  label: Text("Recargar Garantías"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
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
                                style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: warrantyVM.warranties.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: WarrantyCard(
                              warranty: warrantyVM.warranties[index],
                              isSellerView: true,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
